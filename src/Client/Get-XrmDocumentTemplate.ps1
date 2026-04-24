<#
    .SYNOPSIS
    Retrieve Dataverse document templates.

    .DESCRIPTION
    Get a Dataverse document template by reference or by name, with optional entity disambiguation.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TemplateReference
    EntityReference of the Dataverse document template.

    .PARAMETER TemplateName
    Name of the Dataverse document template.

    .PARAMETER AssociatedEntityLogicalName
    Optional logical name of the entity associated with the document template. Use it to disambiguate templates with the same name.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    PSCustomObject. Dataverse document template record.

    .EXAMPLE
    Get-XrmDocumentTemplate -TemplateName "Invoice Template";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Get-XrmDocumentTemplate {
    [CmdletBinding(DefaultParameterSetName = 'ByReference')]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TemplateReference,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $TemplateName,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $AssociatedEntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @('*')
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
            if (-not [string]::IsNullOrWhiteSpace($TemplateReference.LogicalName) -and $TemplateReference.LogicalName -ne 'documenttemplate') {
                throw "TemplateReference logical name must be 'documenttemplate'.";
            }

            return $XrmClient | Get-XrmRecord -LogicalName 'documenttemplate' -Id $TemplateReference.Id -Columns $Columns;
        }

        $resolvedAssociatedEntityLogicalName = $AssociatedEntityLogicalName;
        if (-not [string]::IsNullOrWhiteSpace($AssociatedEntityLogicalName)) {
            $entityMetadata = $XrmClient | Get-XrmEntityMetadata -LogicalName $AssociatedEntityLogicalName -IfExists;
            if ($null -eq $entityMetadata) {
                $matchingEntities = @(
                    $XrmClient | Get-XrmAllEntityMetadata -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity) | Where-Object {
                        $displayName = $null;
                        $displayCollectionName = $null;
                        if ($null -ne $_.DisplayName -and $null -ne $_.DisplayName.UserLocalizedLabel) {
                            $displayName = $_.DisplayName.UserLocalizedLabel.Label;
                        }
                        if ($null -ne $_.DisplayCollectionName -and $null -ne $_.DisplayCollectionName.UserLocalizedLabel) {
                            $displayCollectionName = $_.DisplayCollectionName.UserLocalizedLabel.Label;
                        }

                        $_.SchemaName -ieq $AssociatedEntityLogicalName -or
                        $displayName -ieq $AssociatedEntityLogicalName -or
                        $displayCollectionName -ieq $AssociatedEntityLogicalName;
                    }
                );

                if (@($matchingEntities).Count -eq 1) {
                    $resolvedAssociatedEntityLogicalName = @($matchingEntities)[0].LogicalName;
                }
                elseif (@($matchingEntities).Count -gt 1) {
                    throw "Multiple entities matched '$AssociatedEntityLogicalName'. Use the entity logical name to disambiguate the template lookup.";
                }
            }
        }

        $query = New-XrmQueryExpression -LogicalName 'documenttemplate' -Columns $Columns;
        $query | Add-XrmQueryCondition -Field 'name' -Condition Equal -Values $TemplateName | Out-Null;
        if (-not [string]::IsNullOrWhiteSpace($resolvedAssociatedEntityLogicalName)) {
            $query | Add-XrmQueryCondition -Field 'associatedentitytypecode' -Condition Equal -Values $resolvedAssociatedEntityLogicalName | Out-Null;
        }

        $templates = $XrmClient | Get-XrmMultipleRecords -Query $query;
        if ($null -eq $templates -or @($templates).Count -eq 0) {
            if ([string]::IsNullOrWhiteSpace($AssociatedEntityLogicalName)) {
                throw "Document template '$TemplateName' was not found.";
            }

            throw "Document template '$TemplateName' for entity '$AssociatedEntityLogicalName' was not found.";
        }

        if (@($templates).Count -gt 1) {
            if ([string]::IsNullOrWhiteSpace($AssociatedEntityLogicalName)) {
                throw "Multiple document templates named '$TemplateName' were found. Specify -AssociatedEntityLogicalName to disambiguate the template.";
            }

            throw "Multiple document templates named '$TemplateName' were found for entity '$AssociatedEntityLogicalName'. Use -TemplateReference instead.";
        }

        @($templates)[0];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmDocumentTemplate -Alias *;
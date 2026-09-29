<#
    .SYNOPSIS
    Assign an SVG webresource icon to a Dataverse table.

    .DESCRIPTION
    Validate a Dataverse SVG webresource, assign it to the table IconVectorName metadata property,
    update the table metadata, and optionally publish the customization.
    A table that is not customizable raises an error, or is skipped with a warning when SkipSystemTables is set.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the Dataverse table that should receive the SVG icon.

    .PARAMETER EntityMetadataId
    Table metadata unique identifier. Optional: resolved from EntityLogicalName.

    .PARAMETER WebResourceName
    Name of the Dataverse SVG webresource to assign as the table icon.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the metadata update.

    .PARAMETER PublishChanges
    Whether to publish the table customization after updating the icon. Default: true.

    .PARAMETER SkipSystemTables
    Skip a table that is not customizable (warning, nothing returned) instead of raising an error.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityMetadata. The table metadata read after the update.

    .EXAMPLE
    Set-XrmTableIcon -EntityLogicalName "account" -WebResourceName "new_accounticon.svg";

    .EXAMPLE
    $tables | ForEach-Object { Set-XrmTableIcon -XrmClient $xrmClient -EntityLogicalName $_ -WebResourceName "new_icon.svg" -PublishChanges $false -SkipSystemTables };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmTableIcon.md
#>
function Set-XrmTableIcon {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.EntityMetadata])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [GUID]
        $EntityMetadataId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $WebResourceName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $PublishChanges = $true,

        [Parameter(Mandatory = $false)]
        [switch]
        $SkipSystemTables
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $entityMetadata = $XrmClient | Get-XrmEntityMetadata -LogicalName $EntityLogicalName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity);
        if ($null -ne $entityMetadata.IsCustomizable -and -not $entityMetadata.IsCustomizable.Value) {
            if ($SkipSystemTables) {
                Write-Warning "Table '$EntityLogicalName' is not customizable: icon not set.";
                return;
            }
            throw "Table '$EntityLogicalName' is not customizable: its icon cannot be changed. Use -SkipSystemTables to skip such tables.";
        }

        $webResource = $XrmClient | Get-XrmRecord -LogicalName 'webresource' -AttributeName 'name' -Value $WebResourceName -Columns 'name', 'webresourcetype';
        if ($null -eq $webResource) {
            throw "Webresource '$WebResourceName' was not found.";
        }

        if ($null -eq $webResource.webresourcetype_Value -or $webResource.webresourcetype_Value.Value -ne 11) {
            throw "Webresource '$WebResourceName' must be an SVG webresource (type 11).";
        }

        $setTableParameters = @{
            IconVectorName = $webResource.name;
            MetadataId     = if ($PSBoundParameters.ContainsKey('EntityMetadataId')) { $EntityMetadataId } else { $entityMetadata.MetadataId };
        };
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $setTableParameters['SolutionUniqueName'] = $SolutionUniqueName;
        }

        $updateResponse = $XrmClient | Set-XrmTable @setTableParameters;
        if ($null -eq $updateResponse) {
            throw "Failed to update table '$EntityLogicalName' icon metadata.";
        }

        if ($PublishChanges) {
            $XrmClient | Publish-XrmComponent -ComponentName "entity" -ComponentId $EntityLogicalName | Out-Null;
        }

        $XrmClient | Get-XrmEntityMetadata -LogicalName $EntityLogicalName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity);
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmTableIcon -Alias *;

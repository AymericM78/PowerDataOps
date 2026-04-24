<#
    .SYNOPSIS
    Import a local file content into a Dataverse document template.

    .DESCRIPTION
    Read a file from disk and update the content of an existing Dataverse document template record.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TemplateReference
    EntityReference of the Dataverse document template.

    .PARAMETER TemplateName
    Name of the Dataverse document template.

    .PARAMETER AssociatedEntityLogicalName
    Optional logical name of the entity associated with the document template. Use it to disambiguate templates with the same name.

    .PARAMETER FilePath
    Full path of the local file to import into the template.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. The updated document template reference.

    .EXAMPLE
    Import-XrmDocumentTemplate -TemplateName "Facture-Template" -FilePath "C:\Temp\FactureTemplate.docx";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Import-XrmDocumentTemplate {
    [CmdletBinding(DefaultParameterSetName = 'ByReference')]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [String]
        $FilePath
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $getTemplateParameters = @{
            Columns = @('name', 'associatedentitytypecode');
        };
        if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
            $getTemplateParameters['TemplateReference'] = $TemplateReference;
        }
        else {
            $getTemplateParameters['TemplateName'] = $TemplateName;
            if (-not [string]::IsNullOrWhiteSpace($AssociatedEntityLogicalName)) {
                $getTemplateParameters['AssociatedEntityLogicalName'] = $AssociatedEntityLogicalName;
            }
        }

        $template = $XrmClient | Get-XrmDocumentTemplate @getTemplateParameters;
        $templateContent = Get-XrmBase64 -FilePath $FilePath;

        $templateUpdate = New-XrmEntity -LogicalName 'documenttemplate' -Id $template.Id -Attributes @{
            'content' = $templateContent;
        };
        $XrmClient | Update-XrmRecord -Record $templateUpdate;

        $template.Reference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Import-XrmDocumentTemplate -Alias *;
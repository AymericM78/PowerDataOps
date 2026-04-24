<#
    .SYNOPSIS
    Export a Dataverse document template to a local file.

    .DESCRIPTION
    Read the content of a document template record and save it to a file on disk.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TemplateReference
    EntityReference of the Dataverse document template.

    .PARAMETER TemplateName
    Name of the Dataverse document template.

    .PARAMETER AssociatedEntityLogicalName
    Optional logical name of the entity associated with the document template. Use it to disambiguate templates with the same name.

    .PARAMETER OutputPath
    Full path where the document template content will be written.

    .OUTPUTS
    System.String. The full path of the exported template file.

    .EXAMPLE
    Export-XrmDocumentTemplate -TemplateName "Facture-Template" -OutputPath "C:\Temp\FactureTemplate.docx";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Export-XrmDocumentTemplate {
    [CmdletBinding(DefaultParameterSetName = 'ByReference')]
    [OutputType([System.String])]
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
        [String]
        $OutputPath
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $getTemplateParameters = @{
            Columns = @('name', 'content', 'associatedentitytypecode');
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
        if ([string]::IsNullOrWhiteSpace($template.content)) {
            throw "Document template '$($template.name)' does not contain any file content.";
        }

        Initialize-XrmPath -Path $OutputPath -AsFilePath | Out-Null;
        $templateContent = [System.Convert]::FromBase64String($template.content);
        [System.IO.File]::WriteAllBytes($OutputPath, $templateContent);

        $OutputPath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Export-XrmDocumentTemplate -Alias *;
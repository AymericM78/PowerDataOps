<#
    .SYNOPSIS
    Export a Dataverse record to a Word document using a document template.

    .DESCRIPTION
    Execute the SetWordTemplate action for a Dataverse record, retrieve the generated document annotation, and save the generated Word file locally.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RecordReference
    EntityReference of the Dataverse record to export.

    .PARAMETER TemplateReference
    EntityReference of the Dataverse document template.

    .PARAMETER TemplateName
    Name of the Dataverse document template.

    .PARAMETER AssociatedEntityLogicalName
    Optional logical name of the entity associated with the document template. Defaults to the record logical name in the name-based parameter set.

    .PARAMETER OutputPath
    Full path where the generated Word document will be written.

    .OUTPUTS
    System.String. The full path of the exported Word document.

    .EXAMPLE
    Export-XrmRecordToWord -RecordReference $invoice.Reference -TemplateName "Facture-Template" -OutputPath "C:\Temp\Invoice.docx";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
#>
function Export-XrmRecordToWord {
    [CmdletBinding(DefaultParameterSetName = 'ByTemplateReference')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByTemplateReference')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TemplateReference,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByTemplateName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $TemplateName,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByTemplateName')]
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
        if ($PSCmdlet.ParameterSetName -eq 'ByTemplateName' -and [string]::IsNullOrWhiteSpace($AssociatedEntityLogicalName)) {
            $AssociatedEntityLogicalName = $RecordReference.LogicalName;
        }

        if ($PSCmdlet.ParameterSetName -eq 'ByTemplateName') {
            $template = $XrmClient | Get-XrmDocumentTemplate -TemplateName $TemplateName -AssociatedEntityLogicalName $AssociatedEntityLogicalName -Columns @('name');
            $TemplateReference = $template.Reference;
        }
        elseif (-not [string]::IsNullOrWhiteSpace($TemplateReference.LogicalName) -and $TemplateReference.LogicalName -ne 'documenttemplate') {
            throw "TemplateReference logical name must be 'documenttemplate'.";
        }

        $request = New-XrmRequest -Name 'SetWordTemplate';
        $request | Add-XrmRequestParameter -Name 'Target' -Value $RecordReference | Out-Null;
        $request | Add-XrmRequestParameter -Name 'SelectedTemplate' -Value $TemplateReference | Out-Null;
        $XrmClient | Invoke-XrmRequest -Request $request | Out-Null;

        $queryAnnotation = New-XrmQueryExpression -LogicalName 'annotation' -TopCount 1 -Columns 'documentbody', 'filename';
        $queryAnnotation | Add-XrmQueryCondition -Field 'objectid' -Condition Equal -Values $RecordReference.Id | Out-Null;
        $queryAnnotation | Add-XrmQueryCondition -Field 'isdocument' -Condition Equal -Values $true | Out-Null;
        $queryAnnotation | Add-XrmQueryOrder -Field 'createdon' -OrderType Descending | Out-Null;
        $annotation = ($XrmClient | Get-XrmMultipleRecords -Query $queryAnnotation | Select-Object -First 1);

        if ($null -eq $annotation -or [string]::IsNullOrWhiteSpace($annotation.documentbody)) {
            throw "No generated Word document was found for record '$($RecordReference.LogicalName):$($RecordReference.Id)'.";
        }

        Initialize-XrmPath -Path $OutputPath -AsFilePath | Out-Null;
        $documentContent = [System.Convert]::FromBase64String($annotation.documentbody);
        [System.IO.File]::WriteAllBytes($OutputPath, $documentContent);

        $OutputPath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Export-XrmRecordToWord -Alias *;
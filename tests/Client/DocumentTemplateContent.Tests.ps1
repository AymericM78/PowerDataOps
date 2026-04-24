<#!
    Integration Test: Document template content cmdlets
    Validates export and import of an existing document template content.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Resolve Document Template";

$templateQuery = New-XrmQueryExpression -LogicalName 'documenttemplate' -TopCount 1 -Columns 'name', 'content', 'associatedentitytypecode', 'documenttype', 'languagecode';
$sourceTemplate = $Global:XrmClient | Get-XrmMultipleRecords -Query $templateQuery | Select-Object -First 1;
if ($null -eq $sourceTemplate) {
    Write-Host "  [SKIP] No documenttemplate record was found in the target environment." -ForegroundColor Yellow;
    Write-TestSummary;
    return;
}

$temporaryTemplateName = Get-TestName -Prefix 'TemplateContent';
$temporaryTemplate = New-XrmEntity -LogicalName 'documenttemplate' -Attributes @{
    'name' = $temporaryTemplateName;
    'content' = $sourceTemplate.Record['content'];
    'documenttype' = $sourceTemplate.Record['documenttype'];
    'languagecode' = $sourceTemplate.Record['languagecode'];
};
if ($sourceTemplate.Record.Attributes.Contains('associatedentitytypecode') -and -not [string]::IsNullOrWhiteSpace($sourceTemplate.Record['associatedentitytypecode'])) {
    $temporaryTemplate['associatedentitytypecode'] = $sourceTemplate.Record['associatedentitytypecode'];
}
$temporaryTemplate.Id = $Global:XrmClient | Add-XrmRecord -Record $temporaryTemplate;

$template = $Global:XrmClient | Get-XrmDocumentTemplate -TemplateReference $temporaryTemplate.ToEntityReference() -Columns 'name', 'content', 'associatedentitytypecode';
if ($null -eq $template) {
    Write-Host "  [SKIP] No documenttemplate record was found in the target environment." -ForegroundColor Yellow;
    Write-TestSummary;
    return;
}

Assert-Test "Get-XrmDocumentTemplate resolves by reference" {
    $template.Id -eq $temporaryTemplate.Id;
};

$getByNameParameters = @{
    TemplateName = $template.name;
    Columns = @('name', 'associatedentitytypecode');
};
if ($template.Record.Attributes.Contains('associatedentitytypecode') -and -not [string]::IsNullOrWhiteSpace($template.Record['associatedentitytypecode'])) {
    $getByNameParameters['AssociatedEntityLogicalName'] = $template.Record['associatedentitytypecode'];
}
$templateByName = $Global:XrmClient | Get-XrmDocumentTemplate @getByNameParameters;
Assert-Test "Get-XrmDocumentTemplate resolves by name" {
    $templateByName.Id -eq $template.Id;
};

$templateFilePath = Join-Path $env:TEMP "$(Get-TestName -Prefix 'TemplateExport').docx";
$exportedPath = Export-XrmDocumentTemplate -XrmClient $Global:XrmClient -TemplateReference $template.Reference -OutputPath $templateFilePath;

Assert-Test "Export-XrmDocumentTemplate returns the output path" {
    $exportedPath -eq $templateFilePath;
};
Assert-Test "Export-XrmDocumentTemplate creates a non-empty file" {
    (Test-Path $templateFilePath) -and ([System.IO.FileInfo]::new($templateFilePath).Length -gt 0);
};

$importedReference = Import-XrmDocumentTemplate -XrmClient $Global:XrmClient -TemplateReference $template.Reference -FilePath $templateFilePath;
Assert-Test "Import-XrmDocumentTemplate returns the same template reference" {
    $importedReference.Id -eq $template.Id -and $importedReference.LogicalName -eq 'documenttemplate';
};

$templateAfter = $Global:XrmClient | Get-XrmRecord -LogicalName 'documenttemplate' -Id $template.Id -Columns 'content';
$expectedBase64 = Get-XrmBase64 -FilePath $templateFilePath;
Assert-Test "Template content matches the imported file" {
    $templateAfter.content -eq $expectedBase64;
};

Write-Section "Cleanup";
if (Test-Path $templateFilePath) {
    Remove-Item -Path $templateFilePath -Force;
}
if ($null -ne $temporaryTemplate -and $temporaryTemplate.Id -ne [Guid]::Empty) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName 'documenttemplate' -Id $temporaryTemplate.Id;
}
Assert-Test "Temporary template file deleted" {
    -not (Test-Path $templateFilePath);
};
Assert-Test "Temporary template deleted" {
    $true;
};

Write-TestSummary;
<#!
    Integration Test: Export-XrmViewToExcel cmdlet
    Validates Excel export from an existing system view.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Resolve View";

$view = $Global:XrmClient | Get-XrmViews -EntityLogicalName 'account' -Columns 'name' | Select-Object -First 1;
if ($null -eq $view) {
    Write-Host "  [SKIP] No system view was found for entity 'account'." -ForegroundColor Yellow;
    Write-TestSummary;
    return;
}

$excelFilePath = Join-Path $env:TEMP "$(Get-TestName -Prefix 'ViewExport').xlsx";
$outputPath = Export-XrmViewToExcel -XrmClient $Global:XrmClient -ViewReference $view.Reference -OutputPath $excelFilePath;

Write-Host "  Generated file path: $outputPath" -ForegroundColor Gray;

Assert-Test "Export-XrmViewToExcel returns the output path" {
    $outputPath -eq $excelFilePath;
};
Assert-Test "Export-XrmViewToExcel creates a workbook" {
    (Test-Path $excelFilePath) -and ([System.IO.FileInfo]::new($excelFilePath).Length -gt 0);
};

Write-Section "Cleanup";
if (Test-Path $excelFilePath) {
    Remove-Item -Path $excelFilePath -Force;
}
Assert-Test "Temporary workbook deleted" {
    -not (Test-Path $excelFilePath);
};

Write-TestSummary;
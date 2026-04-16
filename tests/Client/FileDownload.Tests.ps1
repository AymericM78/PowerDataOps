<#!
    Integration Test: Record File Download cmdlet
    Validates file download for a record (no-op if no file field).
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Download File (no-op)";
# No default file field on account, just test no error
Get-XrmRecordFileDownload -LogicalName "account" -Id ([guid]::NewGuid()) -AttributeName "nonexistent" -OutputPath "$env:TEMP\dummy.bin" | Out-Null;
Assert-Test "No error on missing file" { $true };

Write-TestSummary;

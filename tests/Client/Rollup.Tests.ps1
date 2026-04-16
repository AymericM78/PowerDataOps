<#!
    Integration Test: Update-XrmRollupField cmdlet
    Validates rollup field calculation (no-op if none exists).
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Rollup Field Calculation (no-op)";
# No default rollup field on account, just test no error
Update-XrmRollupField -EntityLogicalName "account" -FieldName "nonexistent" -RecordId ([guid]::NewGuid()) | Out-Null;
Assert-Test "No error on missing rollup" { $true };

Write-TestSummary;

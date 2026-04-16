<#!
    Integration Test: Test-XrmView cmdlet
    Validates view validation.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Test View";
$view = Get-XrmRecord -LogicalName "savedquery" -Top 1;
$resp = Test-XrmView -SavedQueryId $view.savedqueryid;
Assert-Test "Validation response" { $resp };

Write-TestSummary;

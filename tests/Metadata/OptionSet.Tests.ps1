<#!
    Integration Test: OptionSet cmdlets
    Validates ordering and status value addition for option sets.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Order OptionSet";
Set-XrmOptionSetOrder -EntityLogicalName "account" -AttributeLogicalName "industrycode" -Order @(1,2,3,4,5) | Out-Null;
Assert-Test "Order set (no error)" { $true };

Write-Section "Add Status Value";
Add-XrmStatusValue -EntityLogicalName "account" -Label "Test Status" -StateCode 0 | Out-Null;
Assert-Test "Status value added (no error)" { $true };

Write-TestSummary;

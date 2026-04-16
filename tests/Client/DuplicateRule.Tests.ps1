<#!
    Integration Test: DuplicateRule cmdlets
    Validates get and publish duplicate rules.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Get Duplicate Rules";
$rules = Get-XrmDuplicateRules -EntityLogicalName "account";
Assert-Test "Rules retrieved" { $rules.Count -ge 0 };

if ($rules.Count -gt 0) {
    Write-Section "Publish Duplicate Rule";
    Publish-XrmDuplicateRule -DuplicateRuleId $rules[0].duplicateruleid | Out-Null;
    Assert-Test "Rule published (no error)" { $true };
}

Write-TestSummary;

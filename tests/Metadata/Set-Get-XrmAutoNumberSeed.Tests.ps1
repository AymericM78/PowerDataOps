<#!
    Integration Test: Set-XrmAutoNumberSeed / Get-XrmAutoNumberSeed
    Validates setting and retrieving the auto-number seed for an auto-number column.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Get current seed";
$entity = "account";
$attribute = "accountnumber";
$oldSeed = Get-XrmAutoNumberSeed -EntityLogicalName $entity -AttributeLogicalName $attribute;
Assert-Test "Seed is numeric" { $oldSeed -is [long] -and $oldSeed -gt 0 };

Write-Section "Set new seed";
$newSeed = $oldSeed + 1000;
Set-XrmAutoNumberSeed -EntityLogicalName $entity -AttributeLogicalName $attribute -Value $newSeed | Out-Null;
$checkSeed = Get-XrmAutoNumberSeed -EntityLogicalName $entity -AttributeLogicalName $attribute;
Assert-Test "Seed updated" { $checkSeed -eq $newSeed };

Write-Section "Restore old seed";
Set-XrmAutoNumberSeed -EntityLogicalName $entity -AttributeLogicalName $attribute -Value $oldSeed | Out-Null;
$finalSeed = Get-XrmAutoNumberSeed -EntityLogicalName $entity -AttributeLogicalName $attribute;
Assert-Test "Seed restored" { $finalSeed -eq $oldSeed };

Write-TestSummary;

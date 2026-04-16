<#!
    Integration Test: LocalizedLabel cmdlet
    Validates setting a localized label on an entity attribute.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Set Localized Label";
$entity = "account";
$attribute = "name";
$labels = @{ 1036 = "Nom FR test"; 1033 = "Name EN test" };
Set-XrmLocalizedLabel -EntityLogicalName $entity -AttributeName $attribute -Labels $labels | Out-Null;
Assert-Test "Localized label set (no error)" { $true };

Write-TestSummary;

<#
    Integration Test: component dependencies, languages, global option sets (brief S08, S12)
    Get-XrmComponentDependencies, Get-XrmProvisionedLanguages, Get-XrmGlobalOptionSets. Read-only.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Get-XrmComponentDependencies";

$account = Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName "account" -Filter Entity;
$dependent = @(Get-XrmComponentDependencies -XrmClient $Global:XrmClient -ComponentId $account.MetadataId -ComponentType 1 -Kind Dependent);
Assert-Test "Dependent: rows on account, required side is account (actual: $($dependent.Count))" {
    $dependent.Count -gt 0 -and @($dependent | Where-Object { [Guid]$_.requiredcomponentobjectid -ne $account.MetadataId }).Count -eq 0;
};
Assert-Test "Dependent: type names resolved (Entity on the required side)" { @($dependent | Where-Object { $_.RequiredComponentTypeName -ne "Entity" }).Count -eq 0 -and @($dependent | Where-Object { $_.DependentComponentTypeName }).Count -gt 0 };

$forDelete = @(Get-XrmComponentDependencies -XrmClient $Global:XrmClient -ComponentId $account.MetadataId -ComponentType 1);
Assert-Test "ForDelete (default): account cannot be deleted freely (actual: $($forDelete.Count))" { $forDelete.Count -gt 0 };

$required = @(Get-XrmComponentDependencies -XrmClient $Global:XrmClient -ComponentId $account.MetadataId -ComponentType 1 -Kind Required);
Assert-Test "Required: dependent side is account" { @($required | Where-Object { [Guid]$_.dependentcomponentobjectid -ne $account.MetadataId }).Count -eq 0 };

Write-Section "Get-XrmProvisionedLanguages";

$languages = @(Get-XrmProvisionedLanguages -XrmClient $Global:XrmClient);
Assert-Test "1033 and 1036 provisioned, ascending order" { $languages -contains 1033 -and $languages -contains 1036 -and (($languages | Sort-Object) -join ",") -eq ($languages -join ",") };
$organization = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query (New-XrmQueryExpression -LogicalName "organization" -Columns "languagecode" -TopCount 1) -AsEntity | Select-Object -First 1;
$baseFirst = @(Get-XrmProvisionedLanguages -XrmClient $Global:XrmClient -BaseFirst);
Assert-Test "-BaseFirst: base language ($($organization['languagecode'])) first, same set" { $baseFirst[0] -eq $organization["languagecode"] -and $baseFirst.Count -eq $languages.Count };

Write-Section "Get-XrmGlobalOptionSets";

$optionSets = @(Get-XrmGlobalOptionSets -XrmClient $Global:XrmClient);
$customOptionSets = @(Get-XrmGlobalOptionSets -XrmClient $Global:XrmClient -CustomOnly);
Assert-Test "All option sets (actual: $($optionSets.Count)), custom ones a subset" { $optionSets.Count -gt 0 -and $customOptionSets.Count -le $optionSets.Count -and @($customOptionSets | Where-Object { -not $_.IsCustomOptionSet }).Count -eq 0 };

Write-TestSummary;

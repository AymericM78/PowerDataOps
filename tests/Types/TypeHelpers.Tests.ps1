<#
    Integration Test: Type Helpers
    Tests all New-Xrm* cmdlets from src/Types/
    Cmdlets: New-XrmEntity, New-XrmEntityReference, New-XrmEntityCollection,
             New-XrmLabel, New-XrmMoney, New-XrmOptionSetValue, New-XrmOptionSetValues,
             New-XrmContext
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# New-XrmEntity
# ============================================================
Write-Section "New-XrmEntity";

# Simple entity
$entity = New-XrmEntity -LogicalName "account";
Assert-Test "New-XrmEntity - LogicalName = 'account'" {
    $entity.LogicalName -eq "account";
};

# Entity with Id
$testId = [Guid]::NewGuid();
$entity = New-XrmEntity -LogicalName "contact" -Id $testId;
Assert-Test "New-XrmEntity with Id" {
    $entity.LogicalName -eq "contact" -and $entity.Id -eq $testId;
};

# Entity with Attributes
$entity = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = "Test";
    "revenue" = New-XrmMoney -Value 1000;
};
Assert-Test "New-XrmEntity with Attributes (name + revenue)" {
    $entity["name"] -eq "Test" -and $entity["revenue"].Value -eq 1000;
};

# ============================================================
# New-XrmEntityReference
# ============================================================
Write-Section "New-XrmEntityReference";

$ref = New-XrmEntityReference -LogicalName "account" -Id $testId;
Assert-Test "New-XrmEntityReference - LogicalName + Id" {
    $ref.LogicalName -eq "account" -and $ref.Id -eq $testId;
};

# ============================================================
# New-XrmEntityCollection
# ============================================================
Write-Section "New-XrmEntityCollection";

$e1 = New-XrmEntity -LogicalName "account" -Attributes @{ "name" = "A" };
$e2 = New-XrmEntity -LogicalName "account" -Attributes @{ "name" = "B" };
$collection = New-XrmEntityCollection -Entities @($e1, $e2);
Assert-Test "New-XrmEntityCollection - 2 entities" {
    $collection.Entities.Count -eq 2;
};

# ============================================================
# New-XrmLabel
# ============================================================
Write-Section "New-XrmLabel";

$labelTest1 = New-XrmLabel -Text "Test Label";
Assert-Test "New-XrmLabel - default lang 1033" {
    $labelTest1.LocalizedLabels[0].Label -eq "Test Label" -and $labelTest1.LocalizedLabels[0].LanguageCode -eq 1033;
};

$labelTest2 = New-XrmLabel -Text "Libelle" -LanguageCode 1036;
Assert-Test "New-XrmLabel - French 1036" {
    $labelTest2.LocalizedLabels[0].Label -eq "Libelle" -and $labelTest2.LocalizedLabels[0].LanguageCode -eq 1036;
};

# ============================================================
# New-XrmMoney
# ============================================================
Write-Section "New-XrmMoney";

$money = New-XrmMoney -Value 99.50;
Assert-Test "New-XrmMoney - Value = 99.50" {
    $money.Value -eq 99.50;
};

# ============================================================
# New-XrmOptionSetValue
# ============================================================
Write-Section "New-XrmOptionSetValue";

$osv = New-XrmOptionSetValue -Value 3;
Assert-Test "New-XrmOptionSetValue - Value = 3" {
    $osv.Value -eq 3;
};

# ============================================================
# New-XrmOptionSetValues
# ============================================================
Write-Section "New-XrmOptionSetValues";

$osvs = New-XrmOptionSetValues -Values @(1, 2, 3);
Assert-Test "New-XrmOptionSetValues - 3 values" {
    $osvs.Count -eq 3 -and $osvs[0].Value -eq 1 -and $osvs[2].Value -eq 3;
};

# ============================================================
Write-TestSummary;

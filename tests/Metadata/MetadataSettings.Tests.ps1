<#
    Integration Test: table, column and relationship settings (brief lot 5: M01 to M07)
    Add-XrmTable / Set-XrmTable flags and -LogicalName, activity table creation, Set-XrmColumn -LogicalName -RequiredLevel -MinValue -MaxValue,
    New-XrmBooleanColumn -TrueLabels -FalseLabels, New-XrmCascadeConfiguration, New-XrmAssociatedMenuConfiguration, Set-XrmRelationship,
    Get-XrmRelationship -IfExists, Get-XrmAlternateKey -IfExists, New-XrmLabel (empty text), ConvertFrom-XrmLabel.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = "new";
$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$tableName = "${prefix}_pdoset$suffix";
$activityName = "${prefix}_pdoact$suffix";
$relationshipName = "${prefix}_account_${tableName}";

# ============================================================
# Labels (local)
# ============================================================
Write-Section "New-XrmLabel / ConvertFrom-XrmLabel";

$emptyLabel = New-XrmLabel -Text "";
Assert-Test "New-XrmLabel -Text '': accepted" { $emptyLabel.LocalizedLabels.Count -eq 1 -and $emptyLabel.LocalizedLabels[0].Label -eq "" };
$converted = ConvertFrom-XrmLabel -Label (New-XrmLabel -Labels @{ 1033 = "Project"; 1036 = "Projet" });
Assert-Test "ConvertFrom-XrmLabel: every language, int keys" { $converted.Count -eq 2 -and $converted[1036] -eq "Projet" -and $converted[1033] -eq "Project" };
$french = ConvertFrom-XrmLabel -Label (New-XrmLabel -Labels @{ 1033 = "Project"; 1036 = "Projet" }) -LanguageCodes 1036;
Assert-Test "-LanguageCodes: filtered" { $french.Count -eq 1 -and $french[1036] -eq "Projet" };
Assert-Test "`$null label: empty hashtable" { (ConvertFrom-XrmLabel -Label $null).Count -eq 0 };

# ============================================================
# Tables
# ============================================================
Write-Section "Add-XrmTable / Set-XrmTable flags";

$Global:XrmClient | Add-XrmTable -LogicalName $tableName -DisplayNameLabels @{ 1033 = "PDO settings $suffix"; 1036 = "Reglages PDO $suffix" } -PluralName "PDO settings" `
    -PrimaryAttributeSchemaName "${prefix}_name" -PrimaryAttributeDisplayName "Name" -IsQuickCreateEnabled $true -ChangeTrackingEnabled $true | Out-Null;
$table = Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName $tableName -Filter Entity;
Assert-Test "Created with IsQuickCreateEnabled and ChangeTrackingEnabled" { $table.IsQuickCreateEnabled -eq $true -and $table.ChangeTrackingEnabled -eq $true };
Assert-Test "ConvertFrom-XrmLabel on table metadata" { (ConvertFrom-XrmLabel -Label $table.DisplayName)[1036] -eq "Reglages PDO $suffix" };

$Global:XrmClient | Set-XrmTable -LogicalName $tableName -IsConnectionsEnabled $true -IsDocumentManagementEnabled $true -SyncToExternalSearchIndex $true -IsQuickCreateEnabled $false | Out-Null;
$table = Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName $tableName -Filter Entity;
Assert-Test "Set-XrmTable -LogicalName: flags applied" {
    $table.IsConnectionsEnabled.Value -eq $true -and $table.IsDocumentManagementEnabled -eq $true -and $table.SyncToExternalSearchIndex -eq $true -and $table.IsQuickCreateEnabled -eq $false;
};
Assert-Test "Untouched flags kept (ChangeTrackingEnabled)" { $table.ChangeTrackingEnabled -eq $true };

$Global:XrmClient | Set-XrmTable -MetadataId $table.MetadataId -IsMailMergeEnabled $false | Out-Null;
$table = Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName $tableName -Filter Entity;
Assert-Test "Set-XrmTable -MetadataId -IsMailMergeEnabled `$false" { $table.IsMailMergeEnabled.Value -eq $false };

$missingIdError = $null;
try { $Global:XrmClient | Set-XrmTable -IsQuickCreateEnabled $true | Out-Null; } catch { $missingIdError = $_.Exception.Message; }
Assert-Test "Neither MetadataId nor LogicalName: error" { $missingIdError -like "*MetadataId or LogicalName*" };

Write-Section "Activity table";
$rulesError = $null;
try { $Global:XrmClient | Add-XrmTable -LogicalName $activityName -DisplayName "PDO activity $suffix" -PluralName "PDO activities" -IsActivity $true -PrimaryAttributeSchemaName "Subject" -PrimaryAttributeDisplayName "Subject" | Out-Null; } catch { $rulesError = $_.Exception.Message; }
Assert-Test "Activity without -HasNotes / -IsAvailableOffline: actionable error before sending" { $rulesError -like "*HasNotes*IsAvailableOffline*" };

$activityError = $null;
try {
    $Global:XrmClient | Add-XrmTable -LogicalName $activityName -DisplayName "PDO activity $suffix" -PluralName "PDO activities" -IsActivity $true -HasNotes $true `
        -PrimaryAttributeSchemaName "Subject" -PrimaryAttributeDisplayName "Subject" -IsAvailableOffline $true -IsQuickCreateEnabled $true -ErrorAction Stop | Out-Null;
}
catch { $activityError = $_.Exception.Message; }
$activity = Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName $activityName -Filter Entity -IfExists;
Assert-Test "Activity table created with -HasNotes -IsAvailableOffline -IsQuickCreateEnabled $(if ($activityError) { "($activityError)" })" { $null -ne $activity -and $activity.IsActivity -eq $true -and $activity.IsQuickCreateEnabled -eq $true };

# ============================================================
# Columns
# ============================================================
Write-Section "Set-XrmColumn -LogicalName -RequiredLevel -MinValue -MaxValue";

$integer = New-XrmIntegerColumn -LogicalName "${prefix}_score" -SchemaName "${prefix}_Score" -DisplayName "Score" -MinValue 0 -MaxValue 100;
$Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $integer | Out-Null;
$money = New-XrmMoneyColumn -LogicalName "${prefix}_budget" -SchemaName "${prefix}_Budget" -DisplayName "Budget" -Precision 2 -MinValue 0 -MaxValue 1000;
$Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $money | Out-Null;

# The test instance accepts UpdateAttribute but keeps the requirement level (SDK .NET and .NET Framework alike):
# the cmdlet must then say so instead of returning as if it worked
$levelError = $null;
try { $Global:XrmClient | Set-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_score" -RequiredLevel ApplicationRequired | Out-Null; } catch { $levelError = $_.Exception.Message; }
$score = Get-XrmColumn -XrmClient $Global:XrmClient -EntityLogicalName $tableName -LogicalName "${prefix}_score";
$levelApplied = $score.RequiredLevel.Value -eq [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::ApplicationRequired;
Assert-Test "RequiredLevel: applied, or an explicit error when the platform kept the old level (applied: $levelApplied)" { ($levelApplied -and $null -eq $levelError) -or (-not $levelApplied -and $levelError -like "*kept its requirement level*") };
Assert-Test "Range kept by the RequiredLevel update" { $score.MinValue -eq 0 -and $score.MaxValue -eq 100 };

$Global:XrmClient | Set-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_score" -MinValue 200 -MaxValue 300 | Out-Null;
$score = Get-XrmColumn -XrmClient $Global:XrmClient -EntityLogicalName $tableName -LogicalName "${prefix}_score";
Assert-Test "Range moved above the old one in one call (200..300)" { $score.MinValue -eq 200 -and $score.MaxValue -eq 300 };

$Global:XrmClient | Set-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_score" -MaxValue 250 | Out-Null;
$score = Get-XrmColumn -XrmClient $Global:XrmClient -EntityLogicalName $tableName -LogicalName "${prefix}_score";
Assert-Test "-MaxValue alone: minimum kept" { $score.MinValue -eq 200 -and $score.MaxValue -eq 250 };

$Global:XrmClient | Set-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_budget" -MinValue -500 -MaxValue 5000.5 | Out-Null;
$budget = Get-XrmColumn -XrmClient $Global:XrmClient -EntityLogicalName $tableName -LogicalName "${prefix}_budget";
Assert-Test "Currency range (-500..5000.5)" { $budget.MinValue -eq -500 -and $budget.MaxValue -eq 5000.5 };

$rangeError = $null;
try { $Global:XrmClient | Set-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_score" -MinValue 400 | Out-Null; } catch { $rangeError = $_.Exception.Message; }
Assert-Test "MinValue above the kept MaxValue: error before sending" { $rangeError -like "*greater than MaxValue*" };

$typeError = $null;
try { $Global:XrmClient | Set-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_name" -MaxValue 10 | Out-Null; } catch { $typeError = $_.Exception.Message; }
Assert-Test "Range on a text column: error" { $typeError -like "*has no MinValue*" };

$locked = (Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName "account" -Filter Attributes).Attributes | Where-Object { $null -ne $_.RequiredLevel -and -not $_.RequiredLevel.CanBeChanged } | Select-Object -First 1;
if ($locked) {
    $otherLevel = $(if ($locked.RequiredLevel.Value -eq [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None) { "ApplicationRequired" } else { "None" });
    $lockedError = $null;
    try { $Global:XrmClient | Set-XrmColumn -EntityLogicalName "account" -LogicalName $locked.LogicalName -RequiredLevel $otherLevel -WhatIf | Out-Null; } catch { $lockedError = $_.Exception.Message; }
    Assert-Test "RequiredLevel.CanBeChanged false ('account.$($locked.LogicalName)'): error before sending" { $lockedError -like "*cannot be changed*" };
}

Write-Section "New-XrmBooleanColumn -TrueLabels -FalseLabels";
$boolean = New-XrmBooleanColumn -LogicalName "${prefix}_enabled" -SchemaName "${prefix}_Enabled" -DisplayName "Enabled" -TrueLabels @{ 1033 = "On"; 1036 = "Marche" } -FalseLabels @{ 1033 = "Off"; 1036 = "Arret" };
$Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $boolean | Out-Null;
$enabled = Get-XrmColumn -XrmClient $Global:XrmClient -EntityLogicalName $tableName -LogicalName "${prefix}_enabled";
Assert-Test "Option labels in both languages" {
    (ConvertFrom-XrmLabel -Label $enabled.OptionSet.TrueOption.Label)[1036] -eq "Marche" -and (ConvertFrom-XrmLabel -Label $enabled.OptionSet.FalseOption.Label)[1033] -eq "Off";
};

# ============================================================
# Relationships
# ============================================================
Write-Section "Set-XrmRelationship / New-XrmCascadeConfiguration / New-XrmAssociatedMenuConfiguration";

Assert-Test "Get-XrmRelationship -IfExists before creation: `$null" { $null -eq (Get-XrmRelationship -XrmClient $Global:XrmClient -Name $relationshipName -IfExists) };

$oneToMany = New-Object Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata;
$oneToMany.SchemaName = $relationshipName;
$oneToMany.ReferencedEntity = "account";
$oneToMany.ReferencingEntity = $tableName;
$oneToMany.ReferencedAttribute = "accountid";
$oneToMany.CascadeConfiguration = New-XrmCascadeConfiguration -Assign NoCascade -Delete RemoveLink -Merge NoCascade -Reparent NoCascade -Share NoCascade -Unshare NoCascade;
$lookup = New-Object Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata;
$lookup.SchemaName = "${prefix}_AccountId";
$lookup.DisplayName = New-XrmLabel -Text "Account";
$lookup.RequiredLevel = New-Object Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None);
$Global:XrmClient | Add-XrmOneToManyRelationship -OneToManyRelationship $oneToMany -Lookup $lookup | Out-Null;

$menu = New-XrmAssociatedMenuConfiguration -Behavior UseLabel -Group Details -Labels @{ 1033 = "PDO rows"; 1036 = "Lignes PDO" } -Order 10500;
$Global:XrmClient | Set-XrmRelationship -Name $relationshipName -CascadeConfiguration (New-XrmCascadeConfiguration -Delete Restrict) -AssociatedMenuConfiguration $menu | Out-Null;
$relationship = Get-XrmRelationship -XrmClient $Global:XrmClient -Name $relationshipName;
Assert-Test "Cascade: Delete Restrict applied, Assign kept (NoCascade)" {
    $relationship.CascadeConfiguration.Delete -eq [Microsoft.Xrm.Sdk.Metadata.CascadeType]::Restrict -and $relationship.CascadeConfiguration.Assign -eq [Microsoft.Xrm.Sdk.Metadata.CascadeType]::NoCascade;
};
Assert-Test "Menu: UseLabel, group, order, French label" {
    $relationship.AssociatedMenuConfiguration.Behavior -eq [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuBehavior]::UseLabel -and $relationship.AssociatedMenuConfiguration.Order -eq 10500 -and
    (ConvertFrom-XrmLabel -Label $relationship.AssociatedMenuConfiguration.Label)[1036] -eq "Lignes PDO";
};

$kindError = $null;
try { $Global:XrmClient | Set-XrmRelationship -Name $relationshipName -Entity1AssociatedMenuConfiguration $menu | Out-Null; } catch { $kindError = $_.Exception.Message; }
Assert-Test "N:N settings on a 1:N relationship: error" { $kindError -like "*one-to-many*" };

$missingError = $null;
try { $Global:XrmClient | Set-XrmRelationship -Name "${prefix}_pdo_missing_$suffix" -CascadeConfiguration (New-XrmCascadeConfiguration -Delete Restrict) | Out-Null; } catch { $missingError = $_.Exception.Message; }
Assert-Test "Missing relationship: error" { $missingError -like "*not found*" };

Assert-Test "Get-XrmAlternateKey -IfExists on a missing key: `$null" { $null -eq (Get-XrmAlternateKey -XrmClient $Global:XrmClient -EntityLogicalName $tableName -LogicalName "${prefix}_pdo_missing_key" -IfExists) };

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
try { $Global:XrmClient | Remove-XrmRelationship -Name $relationshipName | Out-Null; } catch { }
try { $Global:XrmClient | Remove-XrmTable -LogicalName $tableName | Out-Null; } catch { Write-Host "  Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red; }
if ($activity) {
    try { $Global:XrmClient | Remove-XrmTable -LogicalName $activityName | Out-Null; } catch { Write-Host "  Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red; }
}
Assert-Test "Test tables removed" { -not (Test-XrmTable -XrmClient $Global:XrmClient -LogicalName $tableName) -and -not (Test-XrmTable -XrmClient $Global:XrmClient -LogicalName $activityName) };

Write-TestSummary;

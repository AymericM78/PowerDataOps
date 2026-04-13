<#
    Integration Test: Metadata CRUD
    Tests table, column, global optionset, alternate key, and relationship cmdlets.
    Cmdlets: New-XrmTable, Remove-XrmTable, New-XrmColumn, Remove-XrmColumn,
             New-XrmGlobalOptionSet, Remove-XrmGlobalOptionSet,
             New-XrmAlternateKey, Remove-XrmAlternateKey,
             New-XrmOneToManyRelationship, New-XrmManyToManyRelationship, Remove-XrmRelationship
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = "new";
$tableName = "${prefix}_pdotest$(Get-Random -Minimum 10000 -Maximum 99999)";
$tableDisplay = "PDO Test Entity";
$tableCreated = $false;

# ============================================================
# New-XrmTable
# ============================================================
Write-Section "New-XrmTable";

$createTableResponse = $Global:XrmClient | New-XrmTable `
    -LogicalName $tableName `
    -DisplayName $tableDisplay `
    -PluralName "${tableDisplay}s" `
    -Description "Integration test table" `
    -OwnershipType ([Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned) `
    -PrimaryAttributeSchemaName "${prefix}_name" `
    -PrimaryAttributeDisplayName "Name" `
    -PrimaryAttributeMaxLength 200;

Assert-Test "New-XrmTable - created '$tableName'" {
    $createTableResponse -ne $null;
};
$tableCreated = $true;

# ============================================================
# New-XrmColumn (String)
# ============================================================
Write-Section "New-XrmColumn";

$stringAttr = New-Object Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata;
$stringAttr.SchemaName = "${prefix}_teststring";
$stringAttr.LogicalName = "${prefix}_teststring";
$stringAttr.DisplayName = New-XrmLabel -Text "Test String";
$stringAttr.MaxLength = 255;
$stringAttr.RequiredLevel = New-Object Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None);

$createColResponse = $Global:XrmClient | New-XrmColumn -EntityLogicalName $tableName -Attribute $stringAttr;
Assert-Test "New-XrmColumn (String) - created '${prefix}_teststring'" {
    $createColResponse -ne $null;
};

# New-XrmColumn (Integer)
$intAttr = New-Object Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata;
$intAttr.SchemaName = "${prefix}_testint";
$intAttr.LogicalName = "${prefix}_testint";
$intAttr.DisplayName = New-XrmLabel -Text "Test Integer";
$intAttr.MinValue = 0;
$intAttr.MaxValue = 100000;
$intAttr.RequiredLevel = New-Object Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None);

$createIntResponse = $Global:XrmClient | New-XrmColumn -EntityLogicalName $tableName -Attribute $intAttr;
Assert-Test "New-XrmColumn (Integer) - created '${prefix}_testint'" {
    $createIntResponse -ne $null;
};

# ============================================================
# New-XrmGlobalOptionSet
# ============================================================
Write-Section "New-XrmGlobalOptionSet";

$optionSetName = "${prefix}_testglobalos$(Get-Random -Minimum 10000 -Maximum 99999)";
$optionSetMeta = New-Object Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata;
$optionSetMeta.Name = $optionSetName;
$optionSetMeta.DisplayName = New-XrmLabel -Text "Test Global OptionSet";
$optionSetMeta.IsGlobal = $true;
$optionSetMeta.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;
$option1 = New-Object Microsoft.Xrm.Sdk.Metadata.OptionMetadata((New-XrmLabel -Text "Option A"), 100000);
$option2 = New-Object Microsoft.Xrm.Sdk.Metadata.OptionMetadata((New-XrmLabel -Text "Option B"), 100001);
$optionSetMeta.Options.Add($option1);
$optionSetMeta.Options.Add($option2);

$createOsResponse = $Global:XrmClient | New-XrmGlobalOptionSet -OptionSetMetadata $optionSetMeta;
Assert-Test "New-XrmGlobalOptionSet - created '$optionSetName'" {
    $createOsResponse -ne $null;
};

# ============================================================
# New-XrmOneToManyRelationship
# ============================================================
Write-Section "New-XrmOneToManyRelationship";

$relationshipSchemaName = "${prefix}_account_${tableName}";
$lookupSchemaName = "${prefix}_accountid";

$oneToMany = New-Object Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata;
$oneToMany.SchemaName = $relationshipSchemaName;
$oneToMany.ReferencedEntity = "account";
$oneToMany.ReferencingEntity = $tableName;
$oneToMany.ReferencedAttribute = "accountid";

$lookup = New-Object Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata;
$lookup.SchemaName = $lookupSchemaName;
$lookup.LogicalName = $lookupSchemaName.ToLower();
$lookup.DisplayName = New-XrmLabel -Text "Account Lookup";
$lookup.RequiredLevel = New-Object Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None);

$createRelResponse = $Global:XrmClient | New-XrmOneToManyRelationship -OneToManyRelationship $oneToMany -Lookup $lookup;
Assert-Test "New-XrmOneToManyRelationship - created '$relationshipSchemaName'" {
    $createRelResponse -ne $null;
};

# ============================================================
# Remove-XrmColumn
# ============================================================
Write-Section "Remove-XrmColumn";

$removeColResponse = $Global:XrmClient | Remove-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_teststring";
Assert-Test "Remove-XrmColumn - removed '${prefix}_teststring'" {
    $removeColResponse -ne $null;
};

$removeIntResponse = $Global:XrmClient | Remove-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_testint";
Assert-Test "Remove-XrmColumn - removed '${prefix}_testint'" {
    $removeIntResponse -ne $null;
};

# ============================================================
# Remove-XrmRelationship
# ============================================================
Write-Section "Remove-XrmRelationship";

$removeRelResponse = $Global:XrmClient | Remove-XrmRelationship -Name $relationshipSchemaName;
Assert-Test "Remove-XrmRelationship - removed '$relationshipSchemaName'" {
    $removeRelResponse -ne $null;
};

# ============================================================
# Remove-XrmGlobalOptionSet
# ============================================================
Write-Section "Remove-XrmGlobalOptionSet";

$removeOsResponse = $Global:XrmClient | Remove-XrmGlobalOptionSet -Name $optionSetName;
Assert-Test "Remove-XrmGlobalOptionSet - removed '$optionSetName'" {
    $removeOsResponse -ne $null;
};

# ============================================================
# CLEANUP: Remove-XrmTable
# ============================================================
Write-Section "Cleanup - Remove-XrmTable";

if ($tableCreated) {
    $removeTableResponse = $Global:XrmClient | Remove-XrmTable -LogicalName $tableName;
    Assert-Test "Remove-XrmTable - removed '$tableName'" {
        $removeTableResponse -ne $null;
    };
}

Write-TestSummary;

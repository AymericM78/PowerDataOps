<#
    Integration Test: Metadata CRUD
    Tests table, column, global optionset, alternate key, and relationship cmdlets.
    Cmdlets: Add-XrmTable, Remove-XrmTable, Add-XrmColumn, Remove-XrmColumn,
             Add-XrmGlobalOptionSet, Remove-XrmGlobalOptionSet,
             Add-XrmAlternateKey, Remove-XrmAlternateKey,
             Add-XrmOneToManyRelationship, Add-XrmManyToManyRelationship, Remove-XrmRelationship
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = "new";
$tableName = "${prefix}_pdotest$(Get-Random -Minimum 10000 -Maximum 99999)";
$tableDisplay = "PDO Test Entity";
$tableCreated = $false;

# ============================================================
# Add-XrmTable
# ============================================================
Write-Section "Add-XrmTable";

$createTableResponse = $Global:XrmClient | Add-XrmTable `
    -LogicalName $tableName `
    -DisplayName $tableDisplay `
    -PluralName "${tableDisplay}s" `
    -Description "Integration test table" `
    -OwnershipType ([Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned) `
    -PrimaryAttributeSchemaName "${prefix}_name" `
    -PrimaryAttributeDisplayName "Name" `
    -PrimaryAttributeMaxLength 200;

Assert-Test "Add-XrmTable - created '$tableName'" {
    $createTableResponse -ne $null;
};
$tableCreated = $true;
Assert-Test "Test-XrmTable - created table exists" {
    $Global:XrmClient | Test-XrmTable -LogicalName $tableName;
};

$tableMetadata = $Global:XrmClient | Get-XrmEntityMetadata -LogicalName $tableName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity) -IfExists;
Assert-Test "Get-XrmEntityMetadata -IfExists returns created table metadata" {
    $tableMetadata -ne $null -and $tableMetadata.LogicalName -eq $tableName;
};

# ============================================================
# Add-XrmColumn (String)
# ============================================================
Write-Section "Add-XrmColumn";

$stringAttr = New-Object Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata;
$stringAttr.SchemaName = "${prefix}_teststring";
$stringAttr.LogicalName = "${prefix}_teststring";
$stringAttr.DisplayName = New-XrmLabel -Text "Test String";
$stringAttr.MaxLength = 255;
$stringAttr.RequiredLevel = New-Object Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None);

$createColResponse = $Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $stringAttr;
Assert-Test "Add-XrmColumn (String) - created '${prefix}_teststring'" {
    $createColResponse -ne $null;
};
Assert-Test "Test-XrmColumn - string column exists with expected type" {
    $Global:XrmClient | Test-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_teststring" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]);
};

$stringColumn = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_teststring" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]) -IfExists;
Assert-Test "Get-XrmColumn -IfExists returns created string column metadata" {
    $stringColumn -ne $null -and $stringColumn.LogicalName -eq "${prefix}_teststring";
};

$wrongTypeColumn = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_teststring" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata]) -IfExists;
Assert-Test "Get-XrmColumn -IfExists returns null on metadata type mismatch" {
    $null -eq $wrongTypeColumn;
};

# Add-XrmColumn (Integer)
$intAttr = New-Object Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata;
$intAttr.SchemaName = "${prefix}_testint";
$intAttr.LogicalName = "${prefix}_testint";
$intAttr.DisplayName = New-XrmLabel -Text "Test Integer";
$intAttr.MinValue = 0;
$intAttr.MaxValue = 100000;
$intAttr.RequiredLevel = New-Object Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None);

$createIntResponse = $Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $intAttr;
Assert-Test "Add-XrmColumn (Integer) - created '${prefix}_testint'" {
    $createIntResponse -ne $null;
};

# ============================================================
# Add-XrmGlobalOptionSet
# ============================================================
Write-Section "Add-XrmGlobalOptionSet";

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

$createOsResponse = $Global:XrmClient | Add-XrmGlobalOptionSet -OptionSetMetadata $optionSetMeta;
Assert-Test "Add-XrmGlobalOptionSet - created '$optionSetName'" {
    $createOsResponse -ne $null;
};
Assert-Test "Test-XrmGlobalOptionSet - global option set exists" {
    $Global:XrmClient | Test-XrmGlobalOptionSet -Name $optionSetName;
};

$existingOptionSet = $Global:XrmClient | Get-XrmGlobalOptionSet -Name $optionSetName -IfExists;
Assert-Test "Get-XrmGlobalOptionSet -IfExists returns created option set metadata" {
    $existingOptionSet -ne $null -and $existingOptionSet.Name -eq $optionSetName;
};

# ============================================================
# Add-XrmOneToManyRelationship
# ============================================================
Write-Section "Add-XrmOneToManyRelationship";

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

$createRelResponse = $Global:XrmClient | Add-XrmOneToManyRelationship -OneToManyRelationship $oneToMany -Lookup $lookup;
Assert-Test "Add-XrmOneToManyRelationship - created '$relationshipSchemaName'" {
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
Assert-Test "Test-XrmColumn - removed string column no longer exists" {
    -not ($Global:XrmClient | Test-XrmColumn -EntityLogicalName $tableName -LogicalName "${prefix}_teststring");
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
Assert-Test "Test-XrmGlobalOptionSet - removed option set no longer exists" {
    -not ($Global:XrmClient | Test-XrmGlobalOptionSet -Name $optionSetName);
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
    Assert-Test "Test-XrmTable - removed table no longer exists" {
        -not ($Global:XrmClient | Test-XrmTable -LogicalName $tableName);
    };
}

Write-TestSummary;

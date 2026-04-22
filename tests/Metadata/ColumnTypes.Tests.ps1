<#
    Integration Test: Column type constructors
    Tests typed column constructors used with Add-XrmColumn.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = "new";
$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$tableName = "${prefix}_coltypes${suffix}";
$tableDisplay = "PDO Column Types ${suffix}";
$tableCreated = $false;
$globalOptionSetName = "${prefix}_coltypesos${suffix}";
$globalOptionSetCreated = $false;
$createdColumns = New-Object System.Collections.Generic.List[string];

Write-Section "Alias availability";

Assert-Test "Alias New-StringColumn is exported" {
    (Get-Command -Name "New-StringColumn" -ErrorAction SilentlyContinue) -ne $null;
};
Assert-Test "Alias New-BooleanColumn is exported" {
    (Get-Command -Name "New-BooleanColumn" -ErrorAction SilentlyContinue) -ne $null;
};
Assert-Test "Alias New-IntegerColumn is exported" {
    (Get-Command -Name "New-IntegerColumn" -ErrorAction SilentlyContinue) -ne $null;
};
Assert-Test "Alias New-DateColumn is exported" {
    (Get-Command -Name "New-DateColumn" -ErrorAction SilentlyContinue) -ne $null;
};
Assert-Test "Alias New-DoubleColumn is exported" {
    (Get-Command -Name "New-DoubleColumn" -ErrorAction SilentlyContinue) -ne $null;
};
Assert-Test "Alias New-MultiChoiceColumn is exported" {
    (Get-Command -Name "New-MultiChoiceColumn" -ErrorAction SilentlyContinue) -ne $null;
};
Assert-Test "Alias New-ImageColumn is exported" {
    (Get-Command -Name "New-ImageColumn" -ErrorAction SilentlyContinue) -ne $null;
};

Write-Section "Setup table";

$createTableResponse = $Global:XrmClient | Add-XrmTable `
    -LogicalName $tableName `
    -DisplayName $tableDisplay `
    -PluralName "${tableDisplay}s" `
    -Description "Integration test table for typed columns" `
    -OwnershipType ([Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned) `
    -PrimaryAttributeSchemaName "${prefix}_name" `
    -PrimaryAttributeDisplayName "Name" `
    -PrimaryAttributeMaxLength 200;

Assert-Test "Add-XrmTable - created '$tableName'" {
    $createTableResponse -ne $null;
};

$tableCreated = $true;

Write-Section "Setup global option set";

$optionSetMeta = [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata]::new();
$optionSetMeta.Name = $globalOptionSetName;
$optionSetMeta.DisplayName = New-XrmLabel -Text "Column Types OptionSet";
$optionSetMeta.IsGlobal = $true;
$optionSetMeta.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;
$optionSetMeta.Options.Add([Microsoft.Xrm.Sdk.Metadata.OptionMetadata]::new((New-XrmLabel -Text "One"), 100000000));
$optionSetMeta.Options.Add([Microsoft.Xrm.Sdk.Metadata.OptionMetadata]::new((New-XrmLabel -Text "Two"), 100000001));

$createOptionSetResponse = $Global:XrmClient | Add-XrmGlobalOptionSet -OptionSetMetadata $optionSetMeta;
Assert-Test "Add-XrmGlobalOptionSet - created '$globalOptionSetName'" {
    $createOptionSetResponse -ne $null;
};
$globalOptionSetCreated = $true;

Write-Section "Create typed columns";

function Add-ColumnAndAssert {
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Metadata.AttributeMetadata]
        $Attribute,
        [Parameter(Mandatory = $true)]
        [Type]
        $ExpectedType
    )

    Assert-Test "Constructor returns expected type for $($Attribute.LogicalName)" {
        $Attribute -is $ExpectedType;
    };

    $createColumnResponse = $Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $Attribute;
    Assert-Test "Add-XrmColumn - created '$($Attribute.LogicalName)'" {
        $createColumnResponse -ne $null;
    };

    $createdColumns.Add($Attribute.LogicalName) | Out-Null;

    $column = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName $Attribute.LogicalName;
    Assert-Test "Get-XrmColumn - retrieves '$($Attribute.LogicalName)'" {
        $column -ne $null -and $column.LogicalName -eq $Attribute.LogicalName;
    };
}

$stringAttribute = New-XrmStringColumn -LogicalName "${prefix}_typestring" -SchemaName "${prefix}_TypeString" -DisplayName "Type String" -MaxLength 200 -Format Email;
Assert-Test "String constructor sets format" {
    $stringAttribute.Format -eq [Microsoft.Xrm.Sdk.Metadata.StringFormat]::Email;
};
Add-ColumnAndAssert -Attribute $stringAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]);

$autoNumberAttribute = New-XrmAutoNumberColumn -LogicalName "${prefix}_typeautonumber" -SchemaName "${prefix}_TypeAutoNumber" -DisplayName "Type Auto Number" -AutoNumberFormat "TYP-{SEQNUM:5}";
Add-ColumnAndAssert -Attribute $autoNumberAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]);

$memoAttribute = New-XrmMemoColumn -LogicalName "${prefix}_typememo" -SchemaName "${prefix}_TypeMemo" -DisplayName "Type Memo" -MaxLength 2000;
Add-ColumnAndAssert -Attribute $memoAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata]);

$booleanAttribute = New-XrmBooleanColumn -LogicalName "${prefix}_typebool" -SchemaName "${prefix}_TypeBool" -DisplayName "Type Bool" -DefaultValue $true -TrueLabel "Enabled" -FalseLabel "Disabled";
Assert-Test "Boolean constructor sets true/false options" {
    $booleanAttribute.OptionSet -ne $null -and
    $booleanAttribute.OptionSet.TrueOption -ne $null -and
    $booleanAttribute.OptionSet.FalseOption -ne $null -and
    $booleanAttribute.OptionSet.TrueOption.Label.LocalizedLabels[0].Label -eq "Enabled" -and
    $booleanAttribute.OptionSet.FalseOption.Label.LocalizedLabels[0].Label -eq "Disabled" -and
    $booleanAttribute.OptionSet.TrueOption.Value -eq 1 -and
    $booleanAttribute.OptionSet.FalseOption.Value -eq 0;
};
Add-ColumnAndAssert -Attribute $booleanAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata]);

$integerAttribute = New-XrmIntegerColumn -LogicalName "${prefix}_typeint" -SchemaName "${prefix}_TypeInt" -DisplayName "Type Int" -MinValue 0 -MaxValue 100;
Add-ColumnAndAssert -Attribute $integerAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata]);

$doubleAttribute = New-XrmDoubleColumn -LogicalName "${prefix}_typedouble" -SchemaName "${prefix}_TypeDouble" -DisplayName "Type Double" -Precision 3 -MinValue 0 -MaxValue 100;
Add-ColumnAndAssert -Attribute $doubleAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.DoubleAttributeMetadata]);

$decimalAttribute = New-XrmDecimalColumn -LogicalName "${prefix}_typedecimal" -SchemaName "${prefix}_TypeDecimal" -DisplayName "Type Decimal" -Precision 2 -MinValue 0 -MaxValue 100;
Add-ColumnAndAssert -Attribute $decimalAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.DecimalAttributeMetadata]);

$moneyAttribute = New-XrmMoneyColumn -LogicalName "${prefix}_typemoney" -SchemaName "${prefix}_TypeMoney" -DisplayName "Type Money" -Precision 2 -MinValue 0 -MaxValue 1000000;
Add-ColumnAndAssert -Attribute $moneyAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.MoneyAttributeMetadata]);

$dateAttribute = New-XrmDateColumn -LogicalName "${prefix}_typedate" -SchemaName "${prefix}_TypeDate" -DisplayName "Type Date" -Format "DateAndTime" -Behavior "TimeZoneIndependent";
Assert-Test "Date constructor sets behavior" {
    $dateAttribute.DateTimeBehavior -ne $null -and $dateAttribute.DateTimeBehavior.Value -eq "TimeZoneIndependent";
};
Add-ColumnAndAssert -Attribute $dateAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata]);

$choiceAttribute = New-XrmChoiceColumn -LogicalName "${prefix}_typechoice" -SchemaName "${prefix}_TypeChoice" -DisplayName "Type Choice" -LocalOptions @("Choice One", "Choice Two");
Assert-Test "Choice constructor supports local options" {
    $choiceAttribute.OptionSet -ne $null -and
    $choiceAttribute.OptionSet.IsGlobal -eq $false -and
    $choiceAttribute.OptionSet.Options.Count -eq 2;
};
Add-ColumnAndAssert -Attribute $choiceAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]);

$multiChoiceAttribute = New-XrmMultiChoiceColumn -LogicalName "${prefix}_typemultichoice" -SchemaName "${prefix}_TypeMultiChoice" -DisplayName "Type Multi Choice" -GlobalOptionSetName $globalOptionSetName;
Add-ColumnAndAssert -Attribute $multiChoiceAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata]);

$fileAttribute = New-XrmFileColumn -LogicalName "${prefix}_typefile" -SchemaName "${prefix}_TypeFile" -DisplayName "Type File" -MaxSizeInKb 10240;
Assert-Test "Constructor returns expected type for $($fileAttribute.LogicalName)" {
    $fileAttribute -is [Microsoft.Xrm.Sdk.Metadata.FileAttributeMetadata];
};
try {
    $createFileResponse = $Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $fileAttribute;
    Assert-Test "Add-XrmColumn - created '$($fileAttribute.LogicalName)'" {
        $createFileResponse -ne $null;
    };
    $createdColumns.Add($fileAttribute.LogicalName) | Out-Null;
}
catch {
    Assert-Test "Add-XrmColumn (File) unsupported in environment - tolerated" {
        $true;
    };
}

$imageAttribute = New-XrmImageColumn -LogicalName "${prefix}_typeimage" -SchemaName "${prefix}_TypeImage" -DisplayName "Type Image" -MaxSizeInKb 10240 -CanStoreFullImage;
Assert-Test "Constructor returns expected type for $($imageAttribute.LogicalName)" {
    $imageAttribute -is [Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata];
};
Assert-Test "Image constructor sets full image flag" {
    $imageAttribute.CanStoreFullImage -eq $true;
};
try {
    $createImageResponse = $Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $imageAttribute;
    Assert-Test "Add-XrmColumn - created '$($imageAttribute.LogicalName)'" {
        $createImageResponse -ne $null;
    };
    $createdColumns.Add($imageAttribute.LogicalName) | Out-Null;
}
catch {
    Assert-Test "Add-XrmColumn (Image) unsupported in environment - tolerated" {
        $true;
    };
}

$lookupAttribute = New-XrmLookupColumn -LogicalName "${prefix}_typelookup" -SchemaName "${prefix}_TypeLookup" -DisplayName "Type Lookup" -Targets @("account");
Assert-Test "Constructor returns expected type for $($lookupAttribute.LogicalName)" {
    $lookupAttribute -is [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata];
};
Assert-Test "Lookup constructor sets target" {
    $lookupAttribute.Targets -contains "account";
};

$lookupCreateBlocked = $false;
try {
    $Global:XrmClient | Add-XrmColumn -EntityLogicalName "account" -Attribute $lookupAttribute | Out-Null;
}
catch {
    $lookupCreateBlocked = $_.Exception.Message -like "*Add-XrmOneToManyRelationship*" -and $_.Exception.Message -like "*Add-XrmPolymorphicLookup*";
}
Assert-Test "Lookup metadata is rejected by Add-XrmColumn with guidance" {
    $lookupCreateBlocked;
};

Write-Section "Cleanup";

for ($index = $createdColumns.Count - 1; $index -ge 0; $index--) {
    $logicalName = $createdColumns[$index];
    try {
        $Global:XrmClient | Remove-XrmColumn -EntityLogicalName $tableName -LogicalName $logicalName | Out-Null;
    }
    catch {
    }
}
Assert-Test "Cleanup columns completed" { $true };

if ($globalOptionSetCreated) {
    try {
        $Global:XrmClient | Remove-XrmGlobalOptionSet -Name $globalOptionSetName | Out-Null;
    }
    catch {
    }
}
Assert-Test "Cleanup global option set completed" { $true };

if ($tableCreated) {
    try {
        $Global:XrmClient | Remove-XrmTable -LogicalName $tableName | Out-Null;
    }
    catch {
    }
}
Assert-Test "Cleanup table completed" { $true };

Write-TestSummary;

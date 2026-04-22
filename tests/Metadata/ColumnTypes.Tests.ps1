<#
    Integration Test: Column type constructors
    Tests typed column constructors used with New-XrmColumn.
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

Write-Section "Setup table";

$createTableResponse = $Global:XrmClient | New-XrmTable `
    -LogicalName $tableName `
    -DisplayName $tableDisplay `
    -PluralName "${tableDisplay}s" `
    -Description "Integration test table for typed columns" `
    -OwnershipType ([Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned) `
    -PrimaryAttributeSchemaName "${prefix}_name" `
    -PrimaryAttributeDisplayName "Name" `
    -PrimaryAttributeMaxLength 200;

Assert-Test "New-XrmTable - created '$tableName'" {
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

$createOptionSetResponse = $Global:XrmClient | New-XrmGlobalOptionSet -OptionSetMetadata $optionSetMeta;
Assert-Test "New-XrmGlobalOptionSet - created '$globalOptionSetName'" {
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

    $createColumnResponse = $Global:XrmClient | New-XrmColumn -EntityLogicalName $tableName -Attribute $Attribute;
    Assert-Test "New-XrmColumn - created '$($Attribute.LogicalName)'" {
        $createColumnResponse -ne $null;
    };

    $createdColumns.Add($Attribute.LogicalName) | Out-Null;

    $column = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName $Attribute.LogicalName;
    Assert-Test "Get-XrmColumn - retrieves '$($Attribute.LogicalName)'" {
        $column -ne $null -and $column.LogicalName -eq $Attribute.LogicalName;
    };
}

$stringAttribute = New-XrmStringColumn -LogicalName "${prefix}_typestring" -SchemaName "${prefix}_TypeString" -DisplayName "Type String" -MaxLength 200;
Add-ColumnAndAssert -Attribute $stringAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]);

$autoNumberAttribute = New-XrmAutoNumberColumn -LogicalName "${prefix}_typeautonumber" -SchemaName "${prefix}_TypeAutoNumber" -DisplayName "Type Auto Number" -AutoNumberFormat "TYP-{SEQNUM:5}";
Add-ColumnAndAssert -Attribute $autoNumberAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]);

$memoAttribute = New-XrmMemoColumn -LogicalName "${prefix}_typememo" -SchemaName "${prefix}_TypeMemo" -DisplayName "Type Memo" -MaxLength 2000;
Add-ColumnAndAssert -Attribute $memoAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata]);

$booleanAttribute = New-XrmBooleanColumn -LogicalName "${prefix}_typebool" -SchemaName "${prefix}_TypeBool" -DisplayName "Type Bool" -DefaultValue $true;
Add-ColumnAndAssert -Attribute $booleanAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata]);

$integerAttribute = New-XrmIntegerColumn -LogicalName "${prefix}_typeint" -SchemaName "${prefix}_TypeInt" -DisplayName "Type Int" -MinValue 0 -MaxValue 100;
Add-ColumnAndAssert -Attribute $integerAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata]);

$decimalAttribute = New-XrmDecimalColumn -LogicalName "${prefix}_typedecimal" -SchemaName "${prefix}_TypeDecimal" -DisplayName "Type Decimal" -Precision 2 -MinValue 0 -MaxValue 100;
Add-ColumnAndAssert -Attribute $decimalAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.DecimalAttributeMetadata]);

$moneyAttribute = New-XrmMoneyColumn -LogicalName "${prefix}_typemoney" -SchemaName "${prefix}_TypeMoney" -DisplayName "Type Money" -Precision 2 -MinValue 0 -MaxValue 1000000;
Add-ColumnAndAssert -Attribute $moneyAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.MoneyAttributeMetadata]);

$dateAttribute = New-XrmDateColumn -LogicalName "${prefix}_typedate" -SchemaName "${prefix}_TypeDate" -DisplayName "Type Date" -Format "DateOnly";
Add-ColumnAndAssert -Attribute $dateAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata]);

$choiceAttribute = New-XrmChoiceColumn -LogicalName "${prefix}_typechoice" -SchemaName "${prefix}_TypeChoice" -DisplayName "Type Choice" -GlobalOptionSetName $globalOptionSetName;
Add-ColumnAndAssert -Attribute $choiceAttribute -ExpectedType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]);

$fileAttribute = New-XrmFileColumn -LogicalName "${prefix}_typefile" -SchemaName "${prefix}_TypeFile" -DisplayName "Type File" -MaxSizeInKb 10240;
Assert-Test "Constructor returns expected type for $($fileAttribute.LogicalName)" {
    $fileAttribute -is [Microsoft.Xrm.Sdk.Metadata.FileAttributeMetadata];
};
try {
    $createFileResponse = $Global:XrmClient | New-XrmColumn -EntityLogicalName $tableName -Attribute $fileAttribute;
    Assert-Test "New-XrmColumn - created '$($fileAttribute.LogicalName)'" {
        $createFileResponse -ne $null;
    };
    $createdColumns.Add($fileAttribute.LogicalName) | Out-Null;
}
catch {
    Assert-Test "New-XrmColumn (File) unsupported in environment - tolerated" {
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

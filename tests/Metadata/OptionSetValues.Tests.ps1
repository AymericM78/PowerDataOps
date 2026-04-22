<#
    Integration Test: OptionSet Value Management
    Validates New-XrmOption, Add-XrmGlobalOptionSet, Set-XrmGlobalOptionSetOptions,
    Add-XrmOptionSetValue, Set-XrmOptionSetValue, Remove-XrmOptionSetValue,
    and Set-XrmLocalOptionSet using global and local option sets.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$osName = "new_pdoopttest$(Get-Random -Minimum 10000 -Maximum 99999)";
$tableName = "new_pdoopt$(Get-Random -Minimum 10000 -Maximum 99999)";
$localChoiceLogicalName = "new_localchoice";
$tableCreated = $false;

# ============================================================
# SETUP — Create a global option set from typed option definitions
# ============================================================
Write-Section "Setup - create global option set";

$initialGlobalOptions = @(
    (New-XrmOption -Value 100000 -Label (New-XrmLabel -Text "Option A") -Color "#CDDAFD" -ExternalValue "OPTION_A"),
    (New-XrmOption -Value 100001 -Label (New-XrmLabel -Text "Option B") -Color "#FCE1E4")
);

Assert-Test "New-XrmOption - returns OptionMetadata" {
    $initialGlobalOptions[0] -is [Microsoft.Xrm.Sdk.Metadata.OptionMetadata];
};
Assert-Test "New-XrmOption - sets color and external value" {
    $initialGlobalOptions[0].Color -eq "#CDDAFD" -and $initialGlobalOptions[0].ExternalValue -eq "OPTION_A";
};

$createResponse = Add-XrmGlobalOptionSet -Name $osName -DisplayName (New-XrmLabel -Text "PdoTest OptionSet") -Options $initialGlobalOptions;
Assert-Test "Global option set created" {
    $createResponse -ne $null;
};
Assert-Test "Test-XrmGlobalOptionSet - created option set exists" {
    Test-XrmGlobalOptionSet -Name $osName;
};

$osCheck = Get-XrmGlobalOptionSet -Name $osName;
Assert-Test "Global option set has 2 options" {
    $osCheck.Options.Count -eq 2;
};

# ============================================================
# SYNC GLOBAL OPTION SET FROM LIST
# ============================================================
Write-Section "Set-XrmGlobalOptionSetOptions";

$desiredGlobalOptions = @(
    (New-XrmOption -Value 100001 -Label (New-XrmLabel -Text "Option B Updated") -Color "#FCE1E4"),
    (New-XrmOption -Value 100002 -Label (New-XrmLabel -Text "Option C") -Color "#FBF8CC")
);

$syncResponse = Set-XrmGlobalOptionSetOptions -Name $osName -Options $desiredGlobalOptions -DisplayName (New-XrmLabel -Text "PdoTest OptionSet Updated") -RemoveAbsentOptions;
Assert-Test "Global option set synchronized from typed option list" {
    $syncResponse -ne $null -and $syncResponse.Name -eq $osName;
};

$osCheckSync = Get-XrmGlobalOptionSet -Name $osName;
$syncedValues = @($osCheckSync.Options | Where-Object { $null -ne $_.Value } | ForEach-Object { [int]$_.Value });
$syncedOption = $osCheckSync.Options | Where-Object { $_.Value -eq 100001 };
Assert-Test "Global option set sync updates labels and removes missing values" {
    $osCheckSync.DisplayName.UserLocalizedLabel.Label -eq "PdoTest OptionSet Updated" -and
    $syncedValues.Count -eq 2 -and
    $syncedValues[0] -eq 100001 -and
    $syncedValues[1] -eq 100002 -and
    $null -ne $syncedOption -and
    $syncedOption.Label.LocalizedLabels[0].Label -eq "Option B Updated";
};

# ============================================================
# ADD OPTION VALUE
# ============================================================
Write-Section "Add-XrmOptionSetValue";

$addResponse = Add-XrmOptionSetValue -OptionSetName $osName -Value 100003 -Label (New-XrmLabel -Text "Option D") -Color "#DAEAF6" -ExternalValue "OPTION_D";
Assert-Test "Option value 100003 inserted" {
    $addResponse -ne $null;
};

# Verify by retrieving the option set
$osCheckAdd = Get-XrmGlobalOptionSet -Name $osName;
Assert-Test "Option set has 3 options after manual add" {
    $osCheckAdd.Options.Count -eq 3;
};

# ============================================================
# UPDATE OPTION VALUE
# ============================================================
Write-Section "Set-XrmOptionSetValue";

$setResponse = Set-XrmOptionSetValue -OptionSetName $osName -Value 100003 -Label (New-XrmLabel -Text "Option D Updated") -Color "#DAEAF6" -ExternalValue "OPTION_D_UPDATED";
Assert-Test "Option value 100003 updated" {
    $setResponse -ne $null;
};

$osCheckUpdate = Get-XrmGlobalOptionSet -Name $osName;
$option = $osCheckUpdate.Options | Where-Object { $_.Value -eq 100003 };
Assert-Test "Option D label updated" {
    $option.Label.LocalizedLabels[0].Label -eq "Option D Updated";
};

# ============================================================
# REMOVE OPTION VALUE
# ============================================================
Write-Section "Remove-XrmOptionSetValue";

$removeResponse = Remove-XrmOptionSetValue -OptionSetName $osName -Value 100003;
Assert-Test "Option value 100003 deleted" {
    $removeResponse -ne $null;
};

$osCheckRemove = Get-XrmGlobalOptionSet -Name $osName;
Assert-Test "Option set has 2 options remaining after delete" {
    $osCheckRemove.Options.Count -eq 2;
};

# ============================================================
# LOCAL OPTION SET SYNC
# ============================================================
Write-Section "Set-XrmLocalOptionSet";

$createTableResponse = $Global:XrmClient | Add-XrmTable `
    -LogicalName $tableName `
    -DisplayName "PDO Option Test" `
    -PluralName "PDO Option Tests" `
    -PrimaryAttributeSchemaName "new_name" `
    -PrimaryAttributeDisplayName "Name" `
    -PrimaryAttributeMaxLength 200;

Assert-Test "Temporary table created for local option set tests" {
    $createTableResponse -ne $null;
};
$tableCreated = $true;

$localOptions = @(
    (New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Local A") -Color "#CDDAFD"),
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "Local B") -Color "#FCE1E4")
);
$localChoiceColumn = New-XrmChoiceColumn -LogicalName $localChoiceLogicalName -SchemaName "new_LocalChoice" -DisplayName "Local Choice" -Options $localOptions;
$createLocalColumnResponse = $Global:XrmClient | Add-XrmColumn -EntityLogicalName $tableName -Attribute $localChoiceColumn;
Assert-Test "Local choice column created from typed option list" {
    $createLocalColumnResponse -ne $null;
};
Assert-Test "Test-XrmColumn - local choice column exists" {
    $Global:XrmClient | Test-XrmColumn -EntityLogicalName $tableName -LogicalName $localChoiceLogicalName -MetadataType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]);
};

$desiredLocalOptions = @(
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "Local B Updated") -Color "#FCE1E4"),
    (New-XrmOption -Value 100000002 -Label (New-XrmLabel -Text "Local C") -Color "#FBF8CC")
);
$localSyncResponse = $Global:XrmClient | Set-XrmLocalOptionSet -EntityLogicalName $tableName -AttributeLogicalName $localChoiceLogicalName -Options $desiredLocalOptions -RemoveAbsentOptions;
Assert-Test "Local option set synchronized from typed option list" {
    $localSyncResponse -ne $null -and $localSyncResponse.LogicalName -eq $localChoiceLogicalName;
};

$localColumnCheck = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName $localChoiceLogicalName -MetadataType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]) -IfExists;
$localValues = @($localColumnCheck.OptionSet.Options | Where-Object { $null -ne $_.Value } | ForEach-Object { [int]$_.Value });
$localOption = $localColumnCheck.OptionSet.Options | Where-Object { $_.Value -eq 100000001 };
Assert-Test "Local option set sync updates labels and removes missing values" {
    $localColumnCheck -ne $null -and
    $localValues.Count -eq 2 -and
    $localValues[0] -eq 100000001 -and
    $localValues[1] -eq 100000002 -and
    $null -ne $localOption -and
    $localOption.Label.LocalizedLabels[0].Label -eq "Local B Updated";
};

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmGlobalOptionSet -Name $osName | Out-Null;
Assert-Test "Global option set removed" {
    -not (Test-XrmGlobalOptionSet -Name $osName);
};

if ($tableCreated) {
    try {
        $Global:XrmClient | Remove-XrmColumn -EntityLogicalName $tableName -LogicalName $localChoiceLogicalName | Out-Null;
    }
    catch {
    }

    $Global:XrmClient | Remove-XrmTable -LogicalName $tableName | Out-Null;
    Assert-Test "Temporary table removed" {
        -not ($Global:XrmClient | Test-XrmTable -LogicalName $tableName);
    };
}

Write-TestSummary;

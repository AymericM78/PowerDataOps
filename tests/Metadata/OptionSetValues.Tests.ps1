<#
    Integration Test: OptionSet Value Management
    Validates Add-XrmOptionSetValue, Set-XrmOptionSetValue, Remove-XrmOptionSetValue
    using a global option set.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# SETUP — Create a global option set
# ============================================================
Write-Section "Setup - create global option set";

$osName = "new_pdoopttest$(Get-Random -Minimum 10000 -Maximum 99999)";
$osMetadata = [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata]::new();
$osMetadata.Name = $osName;
$osMetadata.DisplayName = New-XrmLabel -Text "PdoTest OptionSet";
$osMetadata.IsGlobal = $true;
$osMetadata.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;

$createResponse = New-XrmGlobalOptionSet -OptionSetMetadata $osMetadata;
Assert-Test "Global option set created" {
    $createResponse -ne $null;
};

# ============================================================
# ADD OPTION VALUE
# ============================================================
Write-Section "Add-XrmOptionSetValue";

$addResponse = Add-XrmOptionSetValue -OptionSetName $osName -Value 100000 -Label (New-XrmLabel -Text "Option A");
Assert-Test "Option value 100000 inserted" {
    $addResponse -ne $null;
};

$addResponse2 = Add-XrmOptionSetValue -OptionSetName $osName -Value 100001 -Label (New-XrmLabel -Text "Option B");
Assert-Test "Option value 100001 inserted" {
    $addResponse2 -ne $null;
};

# Verify by retrieving the option set
$osCheck = Get-XrmGlobalOptionSet -Name $osName;
Assert-Test "Option set has 2 options" {
    $osCheck.Options.Count -eq 2;
};

# ============================================================
# UPDATE OPTION VALUE
# ============================================================
Write-Section "Set-XrmOptionSetValue";

$setResponse = Set-XrmOptionSetValue -OptionSetName $osName -Value 100000 -Label (New-XrmLabel -Text "Option A Updated");
Assert-Test "Option value 100000 updated" {
    $setResponse -ne $null;
};

$osCheck2 = Get-XrmGlobalOptionSet -Name $osName;
$option = $osCheck2.Options | Where-Object { $_.Value -eq 100000 };
Assert-Test "Option A label updated" {
    $option.Label.LocalizedLabels[0].Label -eq "Option A Updated";
};

# ============================================================
# REMOVE OPTION VALUE
# ============================================================
Write-Section "Remove-XrmOptionSetValue";

$removeResponse = Remove-XrmOptionSetValue -OptionSetName $osName -Value 100001;
Assert-Test "Option value 100001 deleted" {
    $removeResponse -ne $null;
};

$osCheck3 = Get-XrmGlobalOptionSet -Name $osName;
Assert-Test "Option set has 1 option remaining" {
    $osCheck3.Options.Count -eq 1;
};

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

Remove-XrmGlobalOptionSet -Name $osName;

Write-TestSummary;

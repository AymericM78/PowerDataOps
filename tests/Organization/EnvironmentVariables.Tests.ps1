<#
    Integration Test: Organization
    Tests environment variable cmdlets.
    Cmdlets: Get-XrmEnvironmentVariableValue, Set-XrmEnvironmentVariableValue
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Setup: Create an environment variable definition + value
# ============================================================
Write-Section "Setup - Create Environment Variable";

$envVarName = "pdo_test_envvar_$(Get-Random -Minimum 10000 -Maximum 99999)";
$envVarInitialValue = "InitialValue_$(Get-Random)";

# Create the environment variable definition
$envVarDef = New-XrmEntity -LogicalName "environmentvariabledefinition" -Attributes @{
    "schemaname"    = $envVarName;
    "displayname"   = "PDO Test Env Var";
    "type"          = (New-XrmOptionSetValue -Value 100000000);
    "defaultvalue"  = $envVarInitialValue;
};
$envVarDef.Id = $Global:XrmClient | Add-XrmRecord -Record $envVarDef;
Assert-Test "Environment variable definition created" {
    $envVarDef.Id -ne [Guid]::Empty;
};

# ============================================================
# Get-XrmEnvironmentVariableValue (default value, no override)
# ============================================================
Write-Section "Get-XrmEnvironmentVariableValue";

$retrievedValue = $Global:XrmClient | Get-XrmEnvironmentVariableValue -Name $envVarName;
Assert-Test "Get-XrmEnvironmentVariableValue - returns default value" {
    $retrievedValue -eq $envVarInitialValue;
};

# ============================================================
# Set-XrmEnvironmentVariableValue
# ============================================================
Write-Section "Set-XrmEnvironmentVariableValue";

$newValue = "UpdatedValue_$(Get-Random)";
$setResponse = $Global:XrmClient | Set-XrmEnvironmentVariableValue -Name $envVarName -Value $newValue;
Assert-Test "Set-XrmEnvironmentVariableValue - value set" {
    $setResponse -ne $null;
};

# Verify updated value
$retrievedUpdated = $Global:XrmClient | Get-XrmEnvironmentVariableValue -Name $envVarName;
Assert-Test "Get-XrmEnvironmentVariableValue - returns updated value" {
    $retrievedUpdated -eq $newValue;
};

# Set to empty string
$setEmptyResponse = $Global:XrmClient | Set-XrmEnvironmentVariableValue -Name $envVarName -Value "";
Assert-Test "Set-XrmEnvironmentVariableValue - set to empty" {
    $setEmptyResponse -ne $null;
};

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

# Delete the environment variable value records
$valueQuery = New-XrmQueryExpression -LogicalName "environmentvariablevalue" -Columns "environmentvariablevalueid";
$valueQuery = $valueQuery | Add-XrmQueryCondition -Field "environmentvariabledefinitionid" -Condition Equal -Values @($envVarDef.Id);
$valueRecords = $Global:XrmClient | Get-XrmMultipleRecords -Query $valueQuery;
foreach ($val in $valueRecords) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName "environmentvariablevalue" -Id $val.Id;
}

# Delete the definition
$Global:XrmClient | Remove-XrmRecord -LogicalName "environmentvariabledefinition" -Id $envVarDef.Id;
Assert-Test "Environment variable cleaned up" { $true };

Write-TestSummary;

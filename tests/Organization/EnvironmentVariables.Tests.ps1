<#
    Integration Test: Organization
    Tests environment variable cmdlets.
    Cmdlets: Get-XrmEnvironmentVariableValue, Set-XrmEnvironmentVariableValue, Get-XrmEnvironmentVariable,
             Get-XrmEnvironmentVariableDefinitions, Upsert-XrmEnvironmentVariableDefinition, Remove-XrmEnvironmentVariableValue
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

$retrievedEmpty = $Global:XrmClient | Get-XrmEnvironmentVariableValue -Name $envVarName;
Assert-Test "Get-XrmEnvironmentVariableValue - an empty override is returned, not the default value" {
    $retrievedEmpty -eq "";
};

# ============================================================
# Get-XrmEnvironmentVariableValue -IfExists
# ============================================================
Write-Section "Get-XrmEnvironmentVariableValue -IfExists";

$missingName = "pdo_missing_envvar_$(Get-Random -Minimum 10000 -Maximum 99999)";
$missingValue = "not set";
$missingError = $null;
try {
    $missingValue = $Global:XrmClient | Get-XrmEnvironmentVariableValue -Name $missingName -IfExists;
}
catch {
    $missingError = $_.Exception.Message;
}
Assert-Test "-IfExists - missing definition returns `$null without error" {
    $null -eq $missingError -and $null -eq $missingValue;
};

$missingError = $null;
try {
    $Global:XrmClient | Get-XrmEnvironmentVariableValue -Name $missingName | Out-Null;
}
catch {
    $missingError = $_.Exception.Message;
}
Assert-Test "Without -IfExists - missing definition raises an error" {
    $missingError -like "*$missingName*not found*";
};

# ============================================================
# W05-W07: definitions, summary, override
# ============================================================
Write-Section "Upsert-XrmEnvironmentVariableDefinition";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$publisherRef = $Global:XrmClient | Add-XrmPublisher -UniqueName "pdoenvvar$suffix" -DisplayName "PDO EnvVar $suffix" -Prefix "pdv" -OptionValuePrefix (10000 + ($suffix % 89999)) -Description "Integration test publisher";
$solutionUniqueName = "pdoenvvarsol$suffix";
$solutionRef = $Global:XrmClient | Add-XrmSolution -UniqueName $solutionUniqueName -DisplayName "PDO EnvVar $suffix" -PublisherReference $publisherRef -Version "1.0.0.0" -Description "Integration test solution";

$schemaName = "pdv_testvar$suffix";
$definitionRef = $Global:XrmClient | Upsert-XrmEnvironmentVariableDefinition -SchemaName $schemaName -DisplayName "PDO Test Var" -DefaultValue "default-1" -SolutionUniqueName $solutionUniqueName;
Assert-Test "Created: definition reference" { $null -ne $definitionRef -and $definitionRef.LogicalName -eq "environmentvariabledefinition" };

$sameRef = $Global:XrmClient | Upsert-XrmEnvironmentVariableDefinition -SchemaName $schemaName -DefaultValue "default-2";
Assert-Test "Second call updates the same definition" { $sameRef.Id -eq $definitionRef.Id };

$components = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @(380));
Assert-Test "-SolutionUniqueName: definition added to the solution (component type 380)" { @($components | Where-Object { [Guid]$_.objectid -eq $definitionRef.Id }).Count -eq 1 };

Write-Section "Get-XrmEnvironmentVariable";
$variable = $Global:XrmClient | Get-XrmEnvironmentVariable -Name $schemaName;
Assert-Test "No override: EffectiveValue = default value" {
    $variable.SchemaName -eq $schemaName -and $variable.Type -eq "String" -and $variable.DefaultValue -eq "default-2" -and -not $variable.HasOverride -and $null -eq $variable.ValueId -and $variable.EffectiveValue -eq "default-2";
};

$valueRef = $Global:XrmClient | Set-XrmEnvironmentVariableValue -Name $schemaName -Value "override-1";
$variable = $Global:XrmClient | Get-XrmEnvironmentVariable -Name $schemaName;
Assert-Test "Override: HasOverride, Value and EffectiveValue" { $variable.HasOverride -and $variable.ValueId -eq $valueRef.Id -and $variable.Value -eq "override-1" -and $variable.EffectiveValue -eq "override-1" };

$modifiedBefore = ($Global:XrmClient | Get-XrmRecord -LogicalName "environmentvariablevalue" -Id $valueRef.Id -Columns "modifiedon" -AsEntity)["modifiedon"];
Start-Sleep -Seconds 2;
$Global:XrmClient | Set-XrmEnvironmentVariableValue -Name $schemaName -Value "override-1" | Out-Null;
$modifiedAfter = ($Global:XrmClient | Get-XrmRecord -LogicalName "environmentvariablevalue" -Id $valueRef.Id -Columns "modifiedon" -AsEntity)["modifiedon"];
Assert-Test "Set-XrmEnvironmentVariableValue with the same value: nothing written" { $modifiedBefore -eq $modifiedAfter };

$Global:XrmClient | Remove-XrmEnvironmentVariableValue -Name $schemaName;
$variable = $Global:XrmClient | Get-XrmEnvironmentVariable -Name $schemaName;
Assert-Test "Remove-XrmEnvironmentVariableValue: back to the default value" { -not $variable.HasOverride -and $variable.EffectiveValue -eq "default-2" };
$Global:XrmClient | Remove-XrmEnvironmentVariableValue -Name $schemaName;
Assert-Test "Remove-XrmEnvironmentVariableValue without override: no error" { $true };

Assert-Test "Get-XrmEnvironmentVariable -IfExists on a missing name: `$null" { $null -eq ($Global:XrmClient | Get-XrmEnvironmentVariable -Name "pdv_missing$suffix" -IfExists) };

$listed = @($Global:XrmClient | Get-XrmEnvironmentVariableDefinitions -Prefix "pdv_testvar$suffix" -Type String);
Assert-Test "Get-XrmEnvironmentVariableDefinitions -Prefix -Type" { $listed.Count -eq 1 -and $listed[0].DefinitionId -eq $definitionRef.Id };

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

try { $Global:XrmClient | Remove-XrmRecord -LogicalName "environmentvariabledefinition" -Id $definitionRef.Id; } catch { }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "solution" -Id $solutionRef.Id; } catch { }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id; } catch { }

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

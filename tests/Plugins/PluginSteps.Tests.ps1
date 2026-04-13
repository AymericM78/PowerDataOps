<#
    Integration Test: Plugin Steps
    Tests Enable-XrmPluginStep and Disable-XrmPluginStep.
    Finds an existing active plugin step, disables it, verifies state, re-enables it.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Find an active plugin step
# ============================================================
Write-Section "Find active plugin step";

$query = New-XrmQueryExpression -LogicalName "sdkmessageprocessingstep" `
    -Columns "name", "sdkmessageprocessingstepid", "statecode", "statuscode" `
    -TopCount 5;
$query = $query | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values @(0);
$query = $query | Add-XrmQueryCondition -Field "ishidden" -Condition Equal -Values @($false);
# Filter custom steps only (not system)
$query = $query | Add-XrmQueryCondition -Field "customizationlevel" -Condition Equal -Values @(1);

$steps = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
$sampleStep = $steps | Select-Object -First 1;

if ($sampleStep) {
    $stepId = $sampleStep.sdkmessageprocessingstepid;
    $stepRef = New-XrmEntityReference -LogicalName "sdkmessageprocessingstep" -Id $stepId;
    Write-Host "    Testing with step: $($sampleStep.name) ($stepId)" -ForegroundColor Gray;

    # ============================================================
    # Disable-XrmPluginStep
    # ============================================================
    Write-Section "Disable-XrmPluginStep";

    try {
        $Global:XrmClient | Disable-XrmPluginStep -PluginStepReference $stepRef;
        Assert-Test "Disable-XrmPluginStep succeeded" { $true };

        # Verify state
        $disabledStep = $Global:XrmClient | Get-XrmRecord -LogicalName "sdkmessageprocessingstep" -Id $stepId -Columns "statecode";
        Assert-Test "Plugin step is now disabled (statecode=1)" {
            $disabledStep.statecode_Value.Value -eq 1;
        };
    }
    catch {
        Assert-Test "Disable-XrmPluginStep failed: $($_.Exception.Message)" { $false };
    }

    # ============================================================
    # Enable-XrmPluginStep
    # ============================================================
    Write-Section "Enable-XrmPluginStep";

    try {
        $Global:XrmClient | Enable-XrmPluginStep -PluginStepReference $stepRef;
        Assert-Test "Enable-XrmPluginStep succeeded" { $true };

        # Verify state
        $enabledStep = $Global:XrmClient | Get-XrmRecord -LogicalName "sdkmessageprocessingstep" -Id $stepId -Columns "statecode";
        Assert-Test "Plugin step is now enabled (statecode=0)" {
            $enabledStep.statecode_Value.Value -eq 0;
        };
    }
    catch {
        Assert-Test "Enable-XrmPluginStep failed: $($_.Exception.Message)" { $false };
    }
}
else {
    Write-Host "  [SKIP] No custom active plugin step found for Enable/Disable test" -ForegroundColor Yellow;
    Assert-Test "Plugin step tests - skipped (no custom step)" { $true };
}

Write-TestSummary;

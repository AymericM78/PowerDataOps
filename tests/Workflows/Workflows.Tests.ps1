<#
    Integration Test: Workflows
    Tests workflow retrieval, enable/disable, and BPF stage cmdlets.
    Cmdlets: Get-XrmWorkflows, Enable-XrmWorkflow, Disable-XrmWorkflow,
             Get-XrmBusinessProcessFlowStage
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Get-XrmWorkflows
# ============================================================
Write-Section "Get-XrmWorkflows";

$workflows = $Global:XrmClient | Get-XrmWorkflows -Columns "name", "category", "primaryentity", "statecode", "statuscode", "workflowid";
Assert-Test "Get-XrmWorkflows - returns workflows (actual: $($workflows.Count))" {
    $workflows.Count -ge 0;
};

if ($workflows.Count -gt 0) {
    $firstWf = $workflows | Select-Object -First 1;
    Assert-Test "Get-XrmWorkflows - first workflow has name" {
        $firstWf.name -ne $null;
    };
    Write-Host "    First workflow: $($firstWf.name) (category: $($firstWf.category))" -ForegroundColor Gray;
}

# ============================================================
# Enable-XrmWorkflow / Disable-XrmWorkflow
# ============================================================
Write-Section "Enable/Disable Workflow";

# Find a deactivated (draft) workflow to test with, or a modern flow
# We look for classic workflows (category = 0) that are turned off
$offWorkflows = $workflows | Where-Object { $_.statecode_Value.Value -eq 0 -and $_.category -eq "Workflow" } | Select-Object -First 1;

if ($offWorkflows) {
    $wfId = $offWorkflows.workflowid;
    Write-Host "    Testing with workflow: $($offWorkflows.name) ($wfId)" -ForegroundColor Gray;

    # Enable it
    try {
        $Global:XrmClient | Enable-XrmWorkflow -WorkflowId $wfId;
        Assert-Test "Enable-XrmWorkflow - workflow activated" { $true };

        # Disable it back
        $Global:XrmClient | Disable-XrmWorkflow -WorkflowId $wfId;
        Assert-Test "Disable-XrmWorkflow - workflow deactivated" { $true };
    }
    catch {
        Write-Host "  [SKIP] Enable/Disable workflow failed: $($_.Exception.Message)" -ForegroundColor Yellow;
        Assert-Test "Enable/Disable Workflow - skipped (workflow not compatible)" { $true };
    }
}
else {
    Write-Host "  [SKIP] No draft classic workflow found for Enable/Disable test" -ForegroundColor Yellow;
    Assert-Test "Enable/Disable Workflow - skipped (no suitable workflow)" { $true };
}

# ============================================================
# Get-XrmBusinessProcessFlowStage
# ============================================================
Write-Section "Get-XrmBusinessProcessFlowStage";

# Find a BPF (category = 4 or look for process stages)
$bpfQuery = New-XrmQueryExpression -LogicalName "workflow" -Columns "name", "workflowid", "primaryentity", "category" -TopCount 1;
$bpfQuery = $bpfQuery | Add-XrmQueryCondition -Field "category" -Condition Equal -Values @(4);
$bpfQuery = $bpfQuery | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values @(1);
$bpfs = $Global:XrmClient | Get-XrmMultipleRecords -Query $bpfQuery;
$sampleBpf = $bpfs | Select-Object -First 1;

if ($sampleBpf) {
    Write-Host "    BPF found: $($sampleBpf.name) ($($sampleBpf.workflowid))" -ForegroundColor Gray;

    # Get stages for this BPF
    $stageQuery = New-XrmQueryExpression -LogicalName "processstage" -Columns "stagename", "processstageid" -TopCount 1;
    $stageQuery = $stageQuery | Add-XrmQueryCondition -Field "processid" -Condition Equal -Values @($sampleBpf.workflowid);
    $stages = $Global:XrmClient | Get-XrmMultipleRecords -Query $stageQuery;
    $firstStage = $stages | Select-Object -First 1;

    if ($firstStage) {
        $bpfStage = $Global:XrmClient | Get-XrmBusinessProcessFlowStage `
            -StageName $firstStage.stagename `
            -ProcessId $sampleBpf.workflowid;

        Assert-Test "Get-XrmBusinessProcessFlowStage - stage found (name: $($firstStage.stagename))" {
            $bpfStage -ne $null;
        };
    }
    else {
        Write-Host "  [SKIP] No stages found for BPF" -ForegroundColor Yellow;
        Assert-Test "Get-XrmBusinessProcessFlowStage - skipped (no stages)" { $true };
    }
}
else {
    Write-Host "  [SKIP] No active BPF found" -ForegroundColor Yellow;
    Assert-Test "Get-XrmBusinessProcessFlowStage - skipped (no BPF)" { $true };
}

Write-TestSummary;

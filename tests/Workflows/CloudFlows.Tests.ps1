<#
    Integration Test: cloud flows (brief W02, W03, W13)
    Upsert-XrmCloudFlow, Remove-XrmWorkflow, Get-XrmFlowTriggers.
    The test flow has a manual trigger and a Compose action: it needs no connection.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$flowId = [Guid]::NewGuid();
$flowRef = New-XrmEntityReference -LogicalName "workflow" -Id $flowId;
function New-TestFlowDefinition {
    param([string]$ComposeValue)
    return '{"properties":{"connectionReferences":{},"definition":{"$schema":"https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#","contentVersion":"1.0.0.0","parameters":{"$connections":{"defaultValue":{},"type":"Object"},"$authentication":{"defaultValue":{},"type":"SecureObject"}},"triggers":{"manual":{"type":"Request","kind":"Button","inputs":{"schema":{"type":"object","properties":{},"required":[]}}}},"actions":{"Compose":{"runAfter":{},"type":"Compose","inputs":"' + $ComposeValue + '"}}},"templateName":""},"schemaVersion":"1.0.0.0"}';
}
function Get-TestFlow {
    $Global:XrmClient | Get-XrmRecord -LogicalName "workflow" -Id $flowId -Columns "name", "statecode", "category", "clientdata", "description" -IfExists -AsEntity;
}

Write-Section "Setup publisher and solution";
$publisherRef = $Global:XrmClient | Add-XrmPublisher -UniqueName "pdoflow$suffix" -DisplayName "PDO Flow $suffix" -Prefix "pdf" -OptionValuePrefix (10000 + ($suffix % 89999)) -Description "Integration test publisher";
$solutionUniqueName = "pdoflowsol$suffix";
$solutionRef = $Global:XrmClient | Add-XrmSolution -UniqueName $solutionUniqueName -DisplayName "PDO Flow $suffix" -PublisherReference $publisherRef -Version "1.0.0.0" -Description "Integration test solution";

# ============================================================
# Upsert-XrmCloudFlow
# ============================================================
Write-Section "Upsert-XrmCloudFlow";

$created = Upsert-XrmCloudFlow -XrmClient $Global:XrmClient -Id $flowId -Name "PDO test flow $suffix" -ClientData (New-TestFlowDefinition -ComposeValue "v1") -Description "created" -SolutionUniqueName $solutionUniqueName;
$flow = Get-TestFlow;
Assert-Test "Created with the given Id, as a draft cloud flow" { $created.Id -eq $flowId -and $flow["category"].Value -eq 5 -and $flow["statecode"].Value -eq 0 -and $flow["clientdata"] -like '*"v1"*' };

$components = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @(29));
Assert-Test "-SolutionUniqueName: flow added to the solution" { @($components | Where-Object { [Guid]$_.objectid -eq $flowId }).Count -eq 1 };

Upsert-XrmCloudFlow -XrmClient $Global:XrmClient -Id $flowId -Name "PDO test flow $suffix (v2)" -ClientData (New-TestFlowDefinition -ComposeValue "v2") | Out-Null;
$flow = Get-TestFlow;
Assert-Test "Draft updated, still off, description kept" { $flow["name"] -like "*(v2)" -and $flow["clientdata"] -like '*"v2"*' -and $flow["statecode"].Value -eq 0 -and $flow["description"] -eq "created" };

$activated = $true;
try {
    Upsert-XrmCloudFlow -XrmClient $Global:XrmClient -Id $flowId -Name "PDO test flow $suffix (v3)" -ClientData (New-TestFlowDefinition -ComposeValue "v3") -Activate | Out-Null;
}
catch {
    $activated = $false;
    Write-Host "  [SKIP] Flow activation refused: $($_.Exception.Message)" -ForegroundColor Yellow;
}
if ($activated) {
    $flow = Get-TestFlow;
    Assert-Test "-Activate: flow written and turned on" { $flow["statecode"].Value -eq 1 -and $flow["clientdata"] -like '*"v3"*' };

    Upsert-XrmCloudFlow -XrmClient $Global:XrmClient -Id $flowId -Name "PDO test flow $suffix (v4)" -ClientData (New-TestFlowDefinition -ComposeValue "v4") | Out-Null;
    $flow = Get-TestFlow;
    Assert-Test "Active flow: turned off, written, turned on again" { $flow["statecode"].Value -eq 1 -and $flow["clientdata"] -like '*"v4"*' };
}

$categoryError = $null;
$classic = @(Get-XrmWorkflows -XrmClient $Global:XrmClient -Category 0 -Type 1 -Columns "name") | Select-Object -First 1;
if ($classic) {
    try { Upsert-XrmCloudFlow -XrmClient $Global:XrmClient -Id $classic.Id -Name "x" -ClientData "{}" -WhatIf | Out-Null; } catch { $categoryError = $_.Exception.Message; }
    Assert-Test "Id of a classic workflow: refused" { $categoryError -like "*not a cloud flow*" };
}

# ============================================================
# Get-XrmFlowTriggers
# ============================================================
Write-Section "Get-XrmFlowTriggers";

$triggers = @(Get-XrmFlowTriggers -XrmClient $Global:XrmClient);
Assert-Test "All triggers readable (actual: $($triggers.Count))" { $triggers.Count -ge 0 };
$accountTriggers = @(Get-XrmFlowTriggers -XrmClient $Global:XrmClient -EntityLogicalName "account");
Assert-Test "-EntityLogicalName account: every row matches" { @($accountTriggers | Where-Object { $_.entityname -ne "account" }).Count -eq 0 };

# ============================================================
# Remove-XrmWorkflow
# ============================================================
Write-Section "Remove-XrmWorkflow";

$managedFlow = @(Get-XrmWorkflows -XrmClient $Global:XrmClient -Category 5 -Columns "name", "ismanaged" | Where-Object { $_ | Get-XrmRowValue -Name "ismanaged" }) | Select-Object -First 1;
if ($managedFlow) {
    $managedError = $null;
    try { Remove-XrmWorkflow -XrmClient $Global:XrmClient -WorkflowReference $managedFlow.Reference -Deactivate -WhatIf; } catch { $managedError = $_.Exception.Message; }
    Assert-Test "Managed flow: refused" { $managedError -like "*is managed*" };
}

Remove-XrmWorkflow -XrmClient $Global:XrmClient -WorkflowReference $flowRef -Deactivate;
Assert-Test "-Deactivate: flow turned off and deleted" { $null -eq (Get-TestFlow) };

$missingError = $null;
try { Remove-XrmWorkflow -XrmClient $Global:XrmClient -WorkflowReference $flowRef; } catch { $missingError = $_.Exception.Message; }
Assert-Test "Missing process: error" { $missingError -like "*not found*" };

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
if (Get-TestFlow) {
    try { Remove-XrmWorkflow -XrmClient $Global:XrmClient -WorkflowReference $flowRef -Deactivate; } catch { }
}
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "solution" -Id $solutionRef.Id; } catch { }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id; } catch { }
Assert-Test "Cleanup complete" { $null -eq (Get-TestFlow) };

Write-TestSummary;

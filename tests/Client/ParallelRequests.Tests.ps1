<#
    Integration Test: parallel and batch writes (brief lot 3b)
    Invoke-XrmParallelRequests, Update-XrmRecords, Upsert-XrmRecords, Add-XrmBulkDelete -Wait.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = Get-TestName -Prefix "Parallel";

function Get-PrefixCount([string]$Suffix = "") {
    $query = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values "$prefix$Suffix";
    return (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query $query);
}

# ============================================================
# Invoke-XrmParallelRequests
# ============================================================
Write-Section "Invoke-XrmParallelRequests";

$ids = @(1..60 | ForEach-Object { [Guid]::NewGuid() });
$createRequests = @(for ($i = 0; $i -lt 60; $i++) {
        Add-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id $ids[$i] -Attributes @{ name = "$prefix-$i" }) -AsRequest;
    });
$createFaults = @(Invoke-XrmParallelRequests -XrmClient $Global:XrmClient -Requests $createRequests -BatchSize 5 -ThreadCount 4 -BypassBusinessLogicExecution CustomSync -Quiet);
Assert-Test "60 creations on 4 threads: no fault returned" { $createFaults.Count -eq 0 };
Assert-Test "60 accounts created" { (Get-PrefixCount) -eq 60 };
Assert-Test "Options added to every request" { @($createRequests | Where-Object { $_.Parameters["BypassBusinessLogicExecution"] -ne "CustomSync" }).Count -eq 0 };

$updateRequests = @(for ($i = 0; $i -lt 20; $i++) {
        $targetId = if ($i -eq 7 -or $i -eq 16) { [Guid]::NewGuid() } else { $ids[$i] };
        Update-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id $targetId -Attributes @{ description = "parallel" }) -AsRequest;
    });
$updateFaults = @(Invoke-XrmParallelRequests -XrmClient $Global:XrmClient -Requests $updateRequests -BatchSize 3 -ThreadCount 3 -ContinueOnError -Quiet);
Assert-Test "-ContinueOnError: the 2 faults, with their global index" {
    $updateFaults.Count -eq 2 -and $updateFaults[0].Index -eq 7 -and $updateFaults[1].Index -eq 16 -and $updateFaults[0].Count -eq 1 -and $updateFaults[0].RequestName -eq "Update" -and $updateFaults[0].Message;
};
Assert-Test "-ContinueOnError: the 18 other updates applied" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query (New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix | Add-XrmQueryCondition -Field "description" -Condition Equal -Values "parallel")) -eq 18 };

$parallelError = $null;
try { Invoke-XrmParallelRequests -XrmClient $Global:XrmClient -Requests $updateRequests -BatchSize 3 -ThreadCount 2 -Quiet | Out-Null; } catch { $parallelError = $_.Exception.Message; }
Assert-Test "Without -ContinueOnError: an error names the first faulted request" { $parallelError -like "Request #*(Update) failed:*" };

$defaultThreadsFaults = @(Invoke-XrmParallelRequests -XrmClient $Global:XrmClient -Requests @($updateRequests[0..5]) -ThreadCount 0 -Quiet);
Assert-Test "-ThreadCount 0 (recommended degree of parallelism)" { $defaultThreadsFaults.Count -eq 0 };

# ============================================================
# Update-XrmRecords / Upsert-XrmRecords
# ============================================================
Write-Section "Update-XrmRecords / Upsert-XrmRecords";

$sequentialUpdates = @(for ($i = 20; $i -lt 30; $i++) { New-XrmEntity -LogicalName "account" -Id $ids[$i] -Attributes @{ description = "sequential" } });
$sequentialFaults = @(Update-XrmRecords -XrmClient $Global:XrmClient -Records $sequentialUpdates -BatchSize 4 -Quiet);
Assert-Test "Update-XrmRecords (sequential): 10 updated, no fault" { $sequentialFaults.Count -eq 0 };

$parallelUpdates = @(for ($i = 30; $i -lt 40; $i++) { New-XrmEntity -LogicalName "account" -Id $ids[$i] -Attributes @{ description = "parallel2" } });
$parallelUpdates += New-XrmEntity -LogicalName "account" -Id ([Guid]::NewGuid()) -Attributes @{ description = "missing" };
$parallelUpdateFaults = @(Update-XrmRecords -XrmClient $Global:XrmClient -Records $parallelUpdates -Parallel -ThreadCount 3 -ContinueOnError -BypassBusinessLogicExecution CustomSync -Quiet);
Assert-Test "Update-XrmRecords -Parallel -ContinueOnError: the missing record is the only fault (index 10)" { $parallelUpdateFaults.Count -eq 1 -and $parallelUpdateFaults[0].Index -eq 10 };

$sequentialFaultsWithError = @(Update-XrmRecords -XrmClient $Global:XrmClient -Records $parallelUpdates -ContinueOnError -Quiet);
Assert-Test "Update-XrmRecords -ContinueOnError (sequential): same fault shape" { $sequentialFaultsWithError.Count -eq 1 -and $sequentialFaultsWithError[0].Index -eq 10 -and $sequentialFaultsWithError[0].RequestName -eq "Update" };

$newIds = @(1..5 | ForEach-Object { [Guid]::NewGuid() });
$upserts = @($newIds | ForEach-Object { New-XrmEntity -LogicalName "account" -Id $_ -Attributes @{ name = "$prefix-upsert" } });
$upsertFaults = @(Upsert-XrmRecords -XrmClient $Global:XrmClient -Records $upserts -Parallel -ThreadCount 2 -Quiet);
Assert-Test "Upsert-XrmRecords -Parallel: 5 created" { $upsertFaults.Count -eq 0 -and (Get-PrefixCount -Suffix "-upsert") -eq 5 };

# ============================================================
# Add-XrmBulkDelete -Wait (also the cleanup)
# ============================================================
Write-Section "Add-XrmBulkDelete -Wait";

$deleteQuery = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix;
$status = $Global:XrmClient | Add-XrmBulkDelete -Query $deleteQuery -JobName "PowerDataOps test $prefix" -Wait -TimeoutInMinutes 20;
Assert-Test "-Wait returns the job status: Succeeded" { $null -ne $status -and $status.Status -eq "Succeeded" };
Assert-Test "All test accounts deleted" { (Get-PrefixCount) -eq 0 };

Write-TestSummary;

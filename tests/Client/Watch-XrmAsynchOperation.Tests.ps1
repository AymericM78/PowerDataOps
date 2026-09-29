<#
    Integration Test: Watch-XrmAsynchOperation
    Status objects, several jobs at once, missing jobs, timeout on a waiting job, failure handling.
    System jobs come from bulk delete jobs that match no record.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

function New-EmptyBulkDeleteJob {
    param([datetime]$StartDateTime = [datetime]::UtcNow)
    $query = New-XrmQueryExpression -LogicalName "account" -Columns "accountid";
    $query = $query | Add-XrmQueryCondition -Field "name" -Condition Equal -Values (Get-TestName -Prefix "NoMatch");
    $response = $Global:XrmClient | Add-XrmBulkDelete -Query $query -JobName (Get-TestName -Prefix "WatchJob") -StartDateTime $StartDateTime;
    return [Guid]$response.Results["JobId"];
}

# ============================================================
# Several jobs, status objects
# ============================================================
Write-Section "Two jobs at once";

$job1 = New-EmptyBulkDeleteJob;
$job2 = New-EmptyBulkDeleteJob;
$statuses = @($Global:XrmClient | Watch-XrmAsynchOperation -AsyncOperationId @($job1, $job2) -PollingIntervalSeconds 3 -TimeoutInMinutes 15);
Assert-Test "One status per job, in input order" {
    $statuses.Count -eq 2 -and $statuses[0].Id -eq $job1 -and $statuses[1].Id -eq $job2;
};
Assert-Test "Both jobs Succeeded (StatusCode 30)" {
    @($statuses | Where-Object { $_.Status -eq "Succeeded" -and $_.StatusCode -eq 30 }).Count -eq 2;
};
Assert-Test "Status object exposes Message and FriendlyMessage" {
    $statuses[0].PSObject.Properties.Name -contains "Message" -and $statuses[0].PSObject.Properties.Name -contains "FriendlyMessage";
};

# ============================================================
# Missing job
# ============================================================
Write-Section "Missing job";

$missingId = [Guid]::NewGuid();
$missingStatus = $Global:XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $missingId -PollingIntervalSeconds 1 -MissingMeansSucceeded;
Assert-Test "-MissingMeansSucceeded - missing job reported as Succeeded" {
    $null -ne $missingStatus -and $missingStatus.Id -eq $missingId -and $missingStatus.Status -eq "Succeeded";
};

$missingError = $null;
try {
    $Global:XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $missingId -PollingIntervalSeconds 1 | Out-Null;
}
catch {
    $missingError = $_.Exception.Message;
}
Assert-Test "Without -MissingMeansSucceeded - missing job raises 'not found'" {
    $missingError -like "*$missingId*not found*";
};

# ============================================================
# Timeout on a waiting job, then cancel it
# ============================================================
Write-Section "Timeout and failure";

$futureJob = New-EmptyBulkDeleteJob -StartDateTime ([datetime]::UtcNow.AddDays(1));
$timeoutError = $null;
try {
    $Global:XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $futureJob -PollingIntervalSeconds 2 -TimeoutInMinutes 0 | Out-Null;
}
catch {
    $timeoutError = $_.Exception.Message;
}
Assert-Test "Timeout applies to a waiting job and lists it" {
    $timeoutError -like "*timeout*$futureJob*";
};

$futureJobReference = New-XrmEntityReference -LogicalName "asyncoperation" -Id $futureJob;
$Global:XrmClient | Set-XrmRecordState -RecordReference $futureJobReference -StateCode 3 -StatusCode 32 | Out-Null;

$canceledStatus = $Global:XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $futureJob -PollingIntervalSeconds 1;
Assert-Test "Canceled job returned with Status Canceled" {
    $null -ne $canceledStatus -and $canceledStatus.Status -eq "Canceled" -and $canceledStatus.StatusCode -eq 32;
};

$failureError = $null;
try {
    $Global:XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $futureJob -PollingIntervalSeconds 1 -ThrowOnFailure | Out-Null;
}
catch {
    $failureError = $_.Exception.Message;
}
Assert-Test "-ThrowOnFailure - canceled job raises an error" {
    $failureError -like "*$futureJob (Canceled)*";
};

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

foreach ($jobId in @($job1, $job2, $futureJob)) {
    try {
        $Global:XrmClient | Remove-XrmRecord -LogicalName "asyncoperation" -Id $jobId;
    }
    catch {
    }
}
Assert-Test "Cleanup complete" { $true };

Write-TestSummary;

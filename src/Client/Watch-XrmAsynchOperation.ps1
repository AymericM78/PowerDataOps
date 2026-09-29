<#
    .SYNOPSIS
    Monitor async operation completion.

    .DESCRIPTION
    Poll the status of one or more system jobs (asyncoperation) until each one reaches a final status: Succeeded (30), Failed (31) or Canceled (32).
    Returns one status object per job, in the order of AsyncOperationId: Id, StatusCode, Status (Waiting, InProgress, Succeeded, Failed, Canceled...), Message, FriendlyMessage.
    The timeout applies whatever the job status, including a job stuck in progress, and raises an error that lists the unfinished jobs.
    A job not found during 10 polls raises an error, unless MissingMeansSucceeded is set: some successful jobs are deleted as soon as they complete.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AsyncOperationId
    System job unique identifier(s).

    .PARAMETER PollingIntervalSeconds
    Delay between each status check. (Default: 5)

    .PARAMETER ScriptBlock
    Command to execute at each poll with the asyncoperation row (once the job has started). Its output is written to the host, not returned.

    .PARAMETER TimeoutInMinutes
    Maximum time to wait for all jobs, whatever their status. (Default: 60)

    .PARAMETER MissingMeansSucceeded
    Consider a job that cannot be found (deleted after completion) as succeeded, instead of raising an error.

    .PARAMETER ThrowOnFailure
    Raise an error when a job ends Failed or Canceled, with its message.

    .OUTPUTS
    PSCustomObject. One object per job: Id, StatusCode, Status, Message, FriendlyMessage.

    .EXAMPLE
    $response = $xrmClient | Invoke-XrmRequest -Request $request -Async;
    $status = $xrmClient | Watch-XrmAsynchOperation -AsyncOperationId $response.AsyncJobId -ThrowOnFailure;

    .EXAMPLE
    $statuses = $xrmClient | Watch-XrmAsynchOperation -AsyncOperationId @($jobId1, $jobId2) -TimeoutInMinutes 30 -MissingMeansSucceeded;
    $statuses | Where-Object { $_.Status -ne "Succeeded" };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmAsynchOperation.md
#>
function Watch-XrmAsynchOperation {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Guid[]]
        $AsyncOperationId,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3600)]
        [int]
        $PollingIntervalSeconds = 5,

        [Parameter(Mandatory = $false)]
        [scriptblock]
        $ScriptBlock,

        [Parameter(Mandatory = $false)]
        [int]
        $TimeoutInMinutes = 60,

        [Parameter(Mandatory = $false)]
        [switch]
        $MissingMeansSucceeded,

        [Parameter(Mandatory = $false)]
        [switch]
        $ThrowOnFailure
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        # Local names are prefixed: scriptblocks built inside the module see this scope (dynamic scoping).
        $watchStatusNames = @{ 0 = "WaitingForResources"; 10 = "Waiting"; 20 = "InProgress"; 21 = "Pausing"; 22 = "Canceling"; 30 = "Succeeded"; 31 = "Failed"; 32 = "Canceled" };
        $watchFinalCodes = @(30, 31, 32);
        $watchWaitingCodes = @(0, 10);
        $watchMaxMissingPolls = if ($MissingMeansSucceeded) { 2 } else { 10 };
        $watchMaxQueryFailures = 10;

        $watchResults = @{};
        $watchMissing = @{};
        $watchLastCode = @{};
        $watchPending = [System.Collections.Generic.List[Guid]]::new();
        foreach ($id in $AsyncOperationId) {
            if (-not $watchPending.Contains($id)) {
                $watchPending.Add($id);
            }
        }
        $watchQueryFailures = 0;
        $watchStartAt = Get-Date;

        while ($watchPending.Count -gt 0) {
            Start-Sleep -Seconds $PollingIntervalSeconds;

            $watchRows = @();
            try {
                $watchQuery = New-XrmQueryExpression -LogicalName "asyncoperation" -Columns "statuscode", "message", "friendlymessage";
                $watchQuery = $watchQuery | Add-XrmQueryCondition -Field "asyncoperationid" -Condition In -Values $watchPending.ToArray();
                $watchRows = @($XrmClient | Get-XrmMultipleRecords -Query $watchQuery);
                $watchQueryFailures = 0;
            }
            catch {
                $watchQueryFailures++;
                if ($watchQueryFailures -ge $watchMaxQueryFailures) {
                    throw "Cannot read async operation status: $($_.Exception.Message)";
                }
                continue;
            }

            foreach ($id in $watchPending.ToArray()) {
                $asyncOperation = $watchRows | Where-Object { $_.Id -eq $id } | Select-Object -First 1;
                if (-not $asyncOperation) {
                    $watchMissing[$id] = 1 + [int]$watchMissing[$id];
                    if ($watchMissing[$id] -lt $watchMaxMissingPolls) {
                        continue;
                    }
                    if (-not $MissingMeansSucceeded) {
                        throw "Asynch operation '$id' not found!";
                    }
                    $watchResults[$id] = [PSCustomObject]@{
                        Id              = $id;
                        StatusCode      = 30;
                        Status          = "Succeeded";
                        Message         = "Not found: deleted after completion, considered as succeeded (MissingMeansSucceeded).";
                        FriendlyMessage = $null;
                    };
                    $watchPending.Remove($id) | Out-Null;
                    continue;
                }
                $watchMissing[$id] = 0;

                $statusCode = [int]$asyncOperation.statuscode_Value.Value;
                $status = if ($watchStatusNames.ContainsKey($statusCode)) { $watchStatusNames[$statusCode] } else { "$statusCode" };
                if ($watchLastCode[$id] -ne $statusCode) {
                    Write-HostAndLog " > Asyncoperation $id : $status" -ForegroundColor Gray;
                    $watchLastCode[$id] = $statusCode;
                }

                if ($ScriptBlock -and -not $watchWaitingCodes.Contains($statusCode)) {
                    Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $asyncOperation | Out-Host;
                }

                if ($watchFinalCodes.Contains($statusCode)) {
                    $watchResults[$id] = [PSCustomObject]@{
                        Id              = $id;
                        StatusCode      = $statusCode;
                        Status          = $status;
                        Message         = $asyncOperation.message;
                        FriendlyMessage = $asyncOperation.friendlymessage;
                    };
                    $watchPending.Remove($id) | Out-Null;
                }
            }

            if ($watchPending.Count -gt 0 -and ((Get-Date) - $watchStartAt).TotalMinutes -gt $TimeoutInMinutes) {
                $watchPendingText = ($watchPending | ForEach-Object { if ($watchLastCode.ContainsKey($_)) { "$_ ($($watchStatusNames[[int]$watchLastCode[$_]]))" } else { "$_ (not found yet)" } }) -join ", ";
                throw "Operation reach timeout ($TimeoutInMinutes min)! Unfinished: $watchPendingText";
            }
        }

        $watchOutput = @($AsyncOperationId | Select-Object -Unique | ForEach-Object { $watchResults[$_] });
        if ($ThrowOnFailure) {
            $watchFailures = @($watchOutput | Where-Object { $_.StatusCode -ne 30 });
            if ($watchFailures.Count -gt 0) {
                $watchFailureText = ($watchFailures | ForEach-Object { "$($_.Id) ($($_.Status)): $(if ($_.FriendlyMessage) { $_.FriendlyMessage } else { $_.Message })" }) -join " | ";
                throw "Async operation failed: $watchFailureText";
            }
        }
        $watchOutput;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Watch-XrmAsynchOperation -Alias *;

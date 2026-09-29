<#
    .SYNOPSIS
    Execute requests in parallel, in small ExecuteMultiple batches.

    .DESCRIPTION
    Send a large set of requests to Microsoft Dataverse on several threads: each thread uses its own clone of the connection (affinity cookie disabled, so the load spreads over the web servers) and takes its batches from a shared queue.
    The ServiceClient retries the service protection errors (429) by itself, honoring the Retry-After delay.
    Returns one object per fault: Index (0-based, global to Requests), Count (1, or the batch size when a whole batch was refused), RequestName, Message. Nothing is returned when every request succeeded.
    Without ContinueOnError, the threads stop taking new batches at the first fault and an error naming it is raised.
    Requires PowerShell 7 for parallelism; on Windows PowerShell 5.1 the batches are sent one after the other.
    Use Invoke-XrmBulkRequests for a sequential run that returns the responses.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Requests
    Requests to execute (e.g. built with Add-, Update-, Upsert- or Remove-XrmRecord -AsRequest).

    .PARAMETER BatchSize
    Number of requests per ExecuteMultiple call, from 1 to 1000. Small batches spread better over threads. (Default: 10)

    .PARAMETER ThreadCount
    Number of threads. 0 uses the RecommendedDegreesOfParallelism of the organization, capped at 52. (Default: 0)

    .PARAMETER ContinueOnError
    Process every request and return the faults, instead of stopping at the first one.

    .PARAMETER Label
    Label of the progress lines. (Default: "Requests")

    .PARAMETER Quiet
    Do not write progress lines.

    .PARAMETER BypassCustomPluginExecution
    Added to every request: legacy bypass of synchronous custom plug-ins.

    .PARAMETER BypassBusinessLogicExecution
    Added to every request: custom business logic to bypass (CustomSync, CustomAsync).

    .PARAMETER BypassBusinessLogicExecutionStepIds
    Added to every request: ids of the plug-in steps to bypass.

    .PARAMETER SuppressCallbackRegistrationExpanderJob
    Added to every request: do not trigger Power Automate flows.

    .PARAMETER SuppressDuplicateDetection
    Added to every request: do not run duplicate detection.

    .PARAMETER Tag
    Added to every request: value shared with the plug-ins.

    .OUTPUTS
    PSCustomObject. One object per fault: Index, Count, RequestName, Message.

    .EXAMPLE
    $requests = $rows | ForEach-Object { Update-XrmRecord -Record $_ -AsRequest };
    $faults = Invoke-XrmParallelRequests -XrmClient $xrmClient -Requests $requests -ContinueOnError -BypassBusinessLogicExecution CustomSync, CustomAsync -Label "Backfill";
    $faults | Format-Table Index, Message;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/send-parallel-requests
#>
function Invoke-XrmParallelRequests {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [Microsoft.Xrm.Sdk.OrganizationRequest[]]
        $Requests,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 1000)]
        [int]
        $BatchSize = 10,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 52)]
        [int]
        $ThreadCount = 0,

        [Parameter(Mandatory = $false)]
        [switch]
        $ContinueOnError,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Label = "Requests",

        [Parameter(Mandatory = $false)]
        [switch]
        $Quiet,

        [Parameter(Mandatory = $false)]
        [switch]
        $BypassCustomPluginExecution,

        [Parameter(Mandatory = $false)]
        [ValidateSet("CustomSync", "CustomAsync")]
        [string[]]
        $BypassBusinessLogicExecution,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid[]]
        $BypassBusinessLogicExecutionStepIds,

        [Parameter(Mandatory = $false)]
        [switch]
        $SuppressCallbackRegistrationExpanderJob,

        [Parameter(Mandatory = $false)]
        [switch]
        $SuppressDuplicateDetection,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Tag
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $Requests -or $Requests.Count -eq 0) {
            return;
        }

        # The workers call the SDK directly (not Invoke-XrmRequest): ShouldProcess is asked once for the whole set
        $hasWrites = @($Requests | Where-Object { -not (Test-XrmReadOnlyRequestInternal -Request $_) }).Count -gt 0;
        if ($hasWrites -and -not $PSCmdlet.ShouldProcess("$($Requests.Count) requests", "Execute in parallel")) {
            return;
        }

        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        if ($options.Count -gt 0) {
            foreach ($request in $Requests) {
                $request | Set-XrmRequestOptions @options | Out-Null;
            }
        }

        # Batches in a shared queue: each thread takes the next one when it is done
        $queue = [System.Collections.Concurrent.ConcurrentQueue[object]]::new();
        for ($start = 0; $start -lt $Requests.Count; $start += $BatchSize) {
            $end = [Math]::Min($start + $BatchSize, $Requests.Count) - 1;
            $queue.Enqueue([PSCustomObject]@{ Start = $start; Requests = [Microsoft.Xrm.Sdk.OrganizationRequest[]]($Requests[$start..$end]) });
        }

        $threads = $ThreadCount;
        if ($threads -eq 0) {
            $threads = [Math]::Min([Math]::Max($XrmClient.RecommendedDegreesOfParallelism, 1), 52);
        }
        $threads = [Math]::Min($threads, $queue.Count);

        $faults = [System.Collections.Concurrent.ConcurrentBag[object]]::new();
        $state = [hashtable]::Synchronized(@{ Done = 0; Total = $Requests.Count; Stop = $false; NextStep = 10 });
        $settings = @{ ContinueOnError = [bool]$ContinueOnError; Label = $Label; Quiet = [bool]$Quiet };

        # The module is not loaded in the parallel runspaces: the worker calls the SDK directly
        $worker = {
            param($Client, $Queue, $Faults, $State, $Settings)

            $batch = $null;
            while (-not $State.Stop -and $Queue.TryDequeue([ref]$batch)) {
                $multiple = [Microsoft.Xrm.Sdk.Messages.ExecuteMultipleRequest]::new();
                $multiple.Settings = [Microsoft.Xrm.Sdk.ExecuteMultipleSettings]::new();
                $multiple.Settings.ContinueOnError = $Settings.ContinueOnError;
                $multiple.Settings.ReturnResponses = $false;
                $multiple.Requests = [Microsoft.Xrm.Sdk.OrganizationRequestCollection]::new();
                foreach ($batchRequest in $batch.Requests) {
                    $multiple.Requests.Add($batchRequest);
                }

                try {
                    $response = $Client.Execute($multiple);
                    foreach ($item in $response.Responses) {
                        if ($null -ne $item.Fault) {
                            $Faults.Add([PSCustomObject]@{
                                    Index       = $batch.Start + $item.RequestIndex;
                                    Count       = 1;
                                    RequestName = $batch.Requests[$item.RequestIndex].RequestName;
                                    Message     = $item.Fault.Message;
                                });
                            if (-not $Settings.ContinueOnError) {
                                $State.Stop = $true;
                            }
                        }
                    }
                }
                catch {
                    $Faults.Add([PSCustomObject]@{
                            Index       = $batch.Start;
                            Count       = $batch.Requests.Count;
                            RequestName = $null;
                            Message     = $_.Exception.GetBaseException().Message;
                        });
                    if (-not $Settings.ContinueOnError) {
                        $State.Stop = $true;
                    }
                }

                [System.Threading.Monitor]::Enter($State.SyncRoot);
                try {
                    $State.Done += $batch.Requests.Count;
                    $percent = [int](($State.Done * 100) / $State.Total);
                    if (-not $Settings.Quiet -and ($percent -ge $State.NextStep -or $State.Done -eq $State.Total)) {
                        Write-Host " > $($Settings.Label): $($State.Done) / $($State.Total) ($percent %)";
                        $State.NextStep = ([Math]::Floor($percent / 10) + 1) * 10;
                    }
                }
                finally {
                    [System.Threading.Monitor]::Exit($State.SyncRoot);
                }
            }
        };

        if ($PSVersionTable.PSVersion.Major -ge 7 -and $threads -gt 1) {
            $clients = [System.Collections.Generic.List[object]]::new();
            # The clones share this setting with the caller's client: restore it at the end, or the caller's
            # next requests lose server affinity (metadata just created then not found on another server)
            $callerAffinityCookie = $XrmClient.EnableAffinityCookie;
            try {
                for ($i = 0; $i -lt $threads; $i++) {
                    $clone = $XrmClient.Clone();
                    $clone.EnableAffinityCookie = $false;
                    $clients.Add($clone);
                }
                $workerText = $worker.ToString();
                $clients | ForEach-Object -ThrottleLimit $threads -Parallel {
                    $runWorker = [scriptblock]::Create($using:workerText);
                    & $runWorker $_ $using:queue $using:faults $using:state $using:settings;
                };
            }
            finally {
                foreach ($clone in $clients) {
                    $clone.Dispose();
                }
                $XrmClient.EnableAffinityCookie = $callerAffinityCookie;
            }
        }
        else {
            & $worker $XrmClient $queue $faults $state $settings;
        }

        $sortedFaults = @($faults.ToArray() | Sort-Object -Property Index);
        if (-not $ContinueOnError -and $sortedFaults.Count -gt 0) {
            $first = $sortedFaults[0];
            throw "Request #$($first.Index) ($($first.RequestName)) failed: $($first.Message)";
        }
        $sortedFaults;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Invoke-XrmParallelRequests -Alias *;

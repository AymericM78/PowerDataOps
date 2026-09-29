<#
    .SYNOPSIS
    Split and Execute Multiple Organization Requests.

    .Description
    Send requests to Microsoft Dataverse for bulk execution, in ExecuteMultiple batches of BatchSize requests.
    Without ContinueOnError, the first fault stops the processing and raises an error that names the faulted request (global index and request name); the requests before it were executed.
    With ContinueOnError, every request is processed. The faults are reported at the end in one non-terminating error whose TargetObject holds one object per fault: Index (0-based, global to the Requests array), Count (1, or the batch size when a whole batch was refused), RequestName and Message. Capture them with -ErrorVariable.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Requests
    Array of organization requests to execute.

    .PARAMETER BatchSize
    Number of requests sent in each ExecuteMultiple call, from 1 to 1000. (Default: 500)

    .PARAMETER ContinueOnError
    Indicates whether to continue with the next requests when a request fails. (Default: false = stop at the first fault)

    .PARAMETER ReturnResponses
    Indicates if a response is returned for each request. (Default: false = No response)

    .PARAMETER Quiet
    Do not log a line for each batch.

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
    Microsoft.Xrm.Sdk.OrganizationResponse. With ReturnResponses, one response per request, in request order ($null for a faulted request).

    .EXAMPLE
    $responses = Invoke-XrmBulkRequests -Requests $requests -ReturnResponses $true;

    .EXAMPLE
    Invoke-XrmBulkRequests -Requests $requests -ContinueOnError $true -ErrorVariable bulkErrors -ErrorAction SilentlyContinue;
    $faults = $bulkErrors | ForEach-Object { $_.TargetObject };
    $faults | Format-Table Index, RequestName, Message;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmBulkRequests.md
#>
function Invoke-XrmBulkRequests {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
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
        $BatchSize = 500,

        [Parameter(Mandatory = $false)]
        [bool]
        $ContinueOnError = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $ReturnResponses = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $Quiet = $false,

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

        [System.Collections.ArrayList] $responses = @();
        if (-Not $Requests) {
            return $responses;
        }

        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        if ($options.Count -gt 0) {
            foreach ($request in $Requests) {
                $request | Set-XrmRequestOptions @options | Out-Null;
            }
        }

        $faults = [System.Collections.Generic.List[PSCustomObject]]::new();
        $total = $Requests.Count;
        for ($start = 0; $start -lt $total; $start += $BatchSize) {
            $end = [Math]::Min($start + $BatchSize, $total) - 1;
            $batch = [Microsoft.Xrm.Sdk.OrganizationRequest[]]($Requests[$start..$end]);

            if (-not $Quiet) {
                Write-HostAndLog -Message " > Processing requests $($start + 1) to $($end + 1) of $total.";
            }
            Write-Progress -Activity "Processing requests" -Status "$($end + 1) / $total" -PercentComplete ((($end + 1) * 100) / $total) -Id 1051;

            try {
                $batchResponse = Invoke-XrmBulkRequest -XrmClient $XrmClient -Requests $batch -ContinueOnError $ContinueOnError -ReturnResponses $ReturnResponses;
            }
            catch {
                if (-not $ContinueOnError) {
                    Write-Progress -Activity "Processing requests" -Id 1051 -Completed;
                    throw "Batch of requests #$start to #$end failed: $($_.Exception.Message)";
                }
                $faults.Add([PSCustomObject]@{
                        Index       = $start;
                        Count       = $batch.Count;
                        RequestName = $null;
                        Message     = $_.Exception.Message;
                    });
                if ($ReturnResponses) {
                    $responses.AddRange([object[]]::new($batch.Count));
                }
                continue;
            }

            $batchResults = [object[]]::new($batch.Count);
            foreach ($item in $batchResponse.Responses) {
                if ($null -eq $item.Fault) {
                    $batchResults[$item.RequestIndex] = $item.Response;
                    continue;
                }

                $fault = [PSCustomObject]@{
                    Index       = $start + $item.RequestIndex;
                    Count       = 1;
                    RequestName = $batch[$item.RequestIndex].RequestName;
                    Message     = $item.Fault.Message;
                };
                if (-not $ContinueOnError) {
                    Write-Progress -Activity "Processing requests" -Id 1051 -Completed;
                    throw "Request #$($fault.Index) ($($fault.RequestName)) failed: $($fault.Message)";
                }
                $faults.Add($fault);
            }

            if ($ReturnResponses) {
                $responses.AddRange($batchResults);
            }
        }
        Write-Progress -Activity "Processing requests" -Id 1051 -Completed;

        $responses;

        if ($faults.Count -gt 0) {
            $faultedCount = 0;
            foreach ($fault in $faults) {
                $faultedCount += $fault.Count;
            }
            $details = ($faults | Select-Object -First 5 | ForEach-Object { "#$($_.Index) ($($_.RequestName)): $($_.Message)" }) -join " | ";
            Write-Error -Message "$faultedCount of $total requests failed. $details" -TargetObject $faults.ToArray() -Category InvalidResult;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Invoke-XrmBulkRequests -Alias *;

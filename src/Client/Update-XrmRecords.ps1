<#
    .SYNOPSIS
    Update many records, in batches, optionally in parallel.

    .DESCRIPTION
    Build one UpdateRequest per record (Update-XrmRecord -AsRequest, with the request options) and send them in ExecuteMultiple batches:
    one after the other (Invoke-XrmBulkRequests), or on several threads with Parallel (Invoke-XrmParallelRequests).
    Returns one object per fault: Index (position in Records), Count, RequestName, Message. Nothing is returned when every update succeeded.
    Without ContinueOnError, the first fault stops the processing and raises an error naming it.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Records
    Records to update: entities with an Id and only the columns to change.

    .PARAMETER Parallel
    Send the batches on several threads (PowerShell 7).

    .PARAMETER BatchSize
    Number of requests per ExecuteMultiple call. (Default: 500 sequential, 10 parallel)

    .PARAMETER ThreadCount
    Number of threads with Parallel. 0 uses the RecommendedDegreesOfParallelism of the organization. (Default: 0)

    .PARAMETER ContinueOnError
    Process every record and return the faults, instead of stopping at the first one.

    .PARAMETER Label
    Label of the progress lines with Parallel. (Default: "Update <table>")

    .PARAMETER Quiet
    Do not write progress lines.

    .PARAMETER BypassCustomPluginExecution
    Legacy bypass of synchronous custom plug-ins.

    .PARAMETER BypassBusinessLogicExecution
    Custom business logic to bypass: CustomSync, CustomAsync, or both.

    .PARAMETER BypassBusinessLogicExecutionStepIds
    Ids of the plug-in steps to bypass.

    .PARAMETER SuppressCallbackRegistrationExpanderJob
    Do not trigger the Power Automate flows.

    .PARAMETER SuppressDuplicateDetection
    Do not run the duplicate detection rules.

    .PARAMETER Tag
    Value shared with the plug-ins.

    .OUTPUTS
    PSCustomObject. One object per fault: Index, Count, RequestName, Message.

    .EXAMPLE
    $updates = $accounts | ForEach-Object { New-XrmEntity -LogicalName "account" -Id $_.Id -Attributes @{ description = "Migrated" } };
    $faults = Update-XrmRecords -XrmClient $xrmClient -Records $updates -Parallel -ContinueOnError -BypassBusinessLogicExecution CustomSync, CustomAsync;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecords.md
#>
function Update-XrmRecords {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Records,

        [Parameter(Mandatory = $false)]
        [switch]
        $Parallel,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 1000)]
        [int]
        $BatchSize,

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
        $Label,

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
        $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
        Invoke-XrmRecordsBatchInternal -XrmClient $XrmClient -Operation "Update" -Records $Records -BatchSize $BatchSize -Parallel:$Parallel -ThreadCount $ThreadCount -ContinueOnError:$ContinueOnError -Label $Label -Quiet:$Quiet -Options $options;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Update-XrmRecords -Alias *;

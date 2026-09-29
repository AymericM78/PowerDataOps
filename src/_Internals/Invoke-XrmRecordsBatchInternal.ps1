<#
    Shared body of Update-XrmRecords / Upsert-XrmRecords: build one request per record (with the request options),
    send them sequentially (Invoke-XrmBulkRequests) or in parallel (Invoke-XrmParallelRequests),
    and return the faults in the same shape either way: Index, Count, RequestName, Message.
#>
function Invoke-XrmRecordsBatchInternal {
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Update", "Upsert")]
        [string]
        $Operation,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [Microsoft.Xrm.Sdk.Entity[]]
        $Records,

        [Parameter(Mandatory = $false)]
        [int]
        $BatchSize = 0,

        [Parameter(Mandatory = $false)]
        [switch]
        $Parallel,

        [Parameter(Mandatory = $false)]
        [int]
        $ThreadCount = 0,

        [Parameter(Mandatory = $false)]
        [switch]
        $ContinueOnError,

        [Parameter(Mandatory = $false)]
        [string]
        $Label,

        [Parameter(Mandatory = $false)]
        [switch]
        $Quiet,

        [Parameter(Mandatory = $true)]
        [hashtable]
        $Options
    )

    if (-not $Records -or $Records.Count -eq 0) {
        return;
    }

    $requests = [Microsoft.Xrm.Sdk.OrganizationRequest[]]@(foreach ($record in $Records) {
            if ($Operation -eq "Update") {
                Update-XrmRecord -XrmClient $XrmClient -Record $record -AsRequest @Options;
            }
            else {
                Upsert-XrmRecord -XrmClient $XrmClient -Record $record -AsRequest @Options;
            }
        });

    if ($Parallel) {
        $parallelParameters = @{
            XrmClient       = $XrmClient;
            Requests        = $requests;
            ThreadCount     = $ThreadCount;
            ContinueOnError = $ContinueOnError;
            Quiet           = $Quiet;
            Label           = $(if ($Label) { $Label } else { "$Operation $($Records[0].LogicalName)" });
        };
        if ($BatchSize -gt 0) {
            $parallelParameters.BatchSize = $BatchSize;
        }
        Invoke-XrmParallelRequests @parallelParameters;
        return;
    }

    $bulkParameters = @{
        XrmClient       = $XrmClient;
        Requests        = $requests;
        ContinueOnError = [bool]$ContinueOnError;
        Quiet           = $Quiet;
    };
    if ($BatchSize -gt 0) {
        $bulkParameters.BatchSize = $BatchSize;
    }
    if (-not $ContinueOnError) {
        Invoke-XrmBulkRequests @bulkParameters | Out-Null;
        return;
    }
    Invoke-XrmBulkRequests @bulkParameters -ErrorVariable bulkErrors -ErrorAction SilentlyContinue | Out-Null;
    @($bulkErrors | ForEach-Object { $_.TargetObject } | Where-Object { $null -ne $_ } | Sort-Object -Property Index);
}

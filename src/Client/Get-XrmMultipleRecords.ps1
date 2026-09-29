<#
    .SYNOPSIS
    Retrieve multiple records with QueryExpression.

    .Description
    Get rows from Microsoft Dataverse table with specified query (QueryBase).
    This command use pagination to pull all records.
    By default the rows are converted to custom objects and written to the pipeline one by one: no row gives nothing and one row gives a single object. Use AsArray to always get an array, and AsEntity to get the SDK Entity objects.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Query
    Query that select and filter data from Microsoft Dataverse table. (QueryBase)

    .PARAMETER PageSize
    Specify row count per page to pull. (Default: 1000)

    .PARAMETER ShowProgress
    Display a progress bar while pages are retrieved.

    .PARAMETER AsArray
    Return the rows as one array, never unrolled: an empty array when nothing matches, an array of one row for a single match.

    .PARAMETER AsEntity
    Return the SDK Entity objects instead of converted custom objects (no formatted value columns).

    .OUTPUTS
    Custom Objects array. Rows (= Entity records) are converted to custom object to simplify data operations. With AsEntity: Microsoft.Xrm.Sdk.Entity.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $queryAccounts = New-XrmQueryExpression -LogicalName "account" -Columns "*" `
                    | Add-XrmQueryCondition -Field "name" -Condition Like -Values "D%" `
                    | Add-XrmQueryCondition -Field "createdon" -Condition LastXMonths -Values 20;
    $accounts = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts;

    .EXAMPLE
    $accounts = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts -AsArray;
    Write-Host "$($accounts.Count) account(s)";

    .EXAMPLE
    $entities = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts -AsEntity -AsArray;

    .LINK
    Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md
#>
function Get-XrmMultipleRecords {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]], [Microsoft.Xrm.Sdk.Entity[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.QueryBase]
        $Query,

        [Parameter(Mandatory = $false)]
        [int]
        $PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [switch]
        $ShowProgress = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsArray,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsEntity
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {

        [System.Collections.ArrayList] $records = @();
        Invoke-XrmQueryPagesInternal -XrmClient $XrmClient -Query $Query -PageSize $PageSize -ShowProgress:$ShowProgress -OnPage {
            param($page)

            if ($page.Entities.Count -eq 0) {
                return;
            }
            if ($AsEntity) {
                $records.AddRange($page.Entities);
                return;
            }
            $objects = $page.Entities | ConvertTo-XrmObjects;
            if ($page.Entities.Count -eq 1) {
                $records.Add($objects) | Out-Null;
            }
            else {
                $records.AddRange($objects);
            }
        };

        if ($AsArray) {
            return , $records.ToArray();
        }
        $records;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmMultipleRecords -Alias *;

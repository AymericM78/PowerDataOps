<#
    .SYNOPSIS
    Retrieve multiple records with QueryExpression.

    .Description
    Get rows from Microsoft Dataverse table with specified query (QueryBase). 
    This command use pagination to pull all records.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Query
    Query that select and filter data from Microsoft Dataverse table. (QueryBase)

    .PARAMETER PageSize
    Specify row count per page to pull. (Default: 1000)

    .OUTPUTS
    Custom Objects array. Rows (= Entity records) are converted to custom object to simplify data operations.

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $queryAccounts = New-XrmQueryExpression -LogicalName "account" -Columns "*" `
                    | Add-XrmQueryCondition -Field "name" -Condition Like -Values "D%" `
                    | Add-XrmQueryCondition -Field "createdon" -Condition LastXMonths -Values 20;
    $accounts = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts;

    .LINK
    Samples: https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/Working%20with%20data.md
#>
function Get-XrmMultipleRecords {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.QueryBase]
        $Query,
        
        [Parameter(Mandatory = $false)]
        [int]
        $PageSize = 1000
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $enablePaging = ($null -eq $Query.TopCount);
        if ($enablePaging) {
            $pageNumber = 1;

            $Query.PageInfo = New-Object -TypeName Microsoft.Xrm.Sdk.Query.PagingInfo;
            $Query.PageInfo.PageNumber = $pageNumber;
            $Query.PageInfo.Count = $PageSize;
            $Query.PageInfo.PagingCookie = $null;
        }

        [System.Collections.ArrayList] $records = @();
        while ($true) {
            $results = Protect-XrmCommand -ScriptBlock { $XrmClient.RetrieveMultiple($Query) };
            if ($enablePaging) {
                Write-Progress -Activity "Retrieving data from CRM" -Status "Processing record page : $pageNumber" -PercentComplete -1;
            }
            if ($results.Entities.Count -gt 0) {
                $objects = $results.Entities | ConvertTo-XrmObjects;
                $records.AddRange($objects);
            }
            if ($enablePaging -and $results.MoreRecords) {
                $pageNumber++;
                $Query.PageInfo.PageNumber = $pageNumber;
                $Query.PageInfo.PagingCookie = $results.PagingCookie;
            }
            else {
                break;
            }
        }
        if ($enablePaging) {
            Write-Progress one one -completed;
        }
        $records;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmMultipleRecords -Alias *;
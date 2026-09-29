<#
    Run a query (QueryExpression or QueryByAttribute) page by page and pass each page (EntityCollection) to OnPage.
    Paging is enabled when the query has no TopCount. The query PageInfo is overwritten, as Get-XrmMultipleRecords always did.
    A failed page stops the loop (the error is written as before, with what was read so far).
    OnPage runs in a child scope: accumulate into a reference type (list, hashset, hashtable).
#>
function Invoke-XrmQueryPagesInternal {
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.QueryBase]
        $Query,

        [Parameter(Mandatory = $false)]
        [int]
        $PageSize = 1000,

        [Parameter(Mandatory = $false)]
        [switch]
        $ShowProgress,

        [Parameter(Mandatory = $true)]
        [scriptblock]
        $OnPage
    )

    $enablePaging = ($null -eq $Query.TopCount);
    $pageNumber = 1;
    if ($enablePaging) {
        $Query.PageInfo = [Microsoft.Xrm.Sdk.Query.PagingInfo]::new();
        $Query.PageInfo.PageNumber = $pageNumber;
        $Query.PageInfo.Count = $PageSize;
        $Query.PageInfo.PagingCookie = $null;
    }

    while ($true) {
        $results = Protect-XrmCommand -ScriptBlock { $XrmClient.RetrieveMultiple($Query) };
        if ($null -eq $results) {
            break;
        }
        if ($enablePaging -and $ShowProgress) {
            Write-Progress -Activity "Retrieving data from Microsoft Dataverse" -Status "Processing record page : $pageNumber" -PercentComplete -1 -Id 1050;
        }

        & $OnPage $results;

        if ($enablePaging -and $results.MoreRecords) {
            $pageNumber++;
            $Query.PageInfo.PageNumber = $pageNumber;
            $Query.PageInfo.PagingCookie = $results.PagingCookie;
        }
        else {
            break;
        }
    }
    if ($enablePaging -and $ShowProgress) {
        Write-Progress -Activity "Retrieving data from Microsoft Dataverse" -Id 1050 -Completed;
    }
}

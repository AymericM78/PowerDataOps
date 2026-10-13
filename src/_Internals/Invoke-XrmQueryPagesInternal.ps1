<#
    Run a query (QueryExpression, QueryByAttribute or FetchExpression) page by page and pass each page (EntityCollection) to OnPage.
    Paging is enabled when the query has no TopCount. The query PageInfo is overwritten, as Get-XrmMultipleRecords always did.
    A FetchExpression is paged through its page, count and paging-cookie attributes, on a copy of its XML (count becomes PageSize);
    a fetch with top, or an aggregate fetch, is read in one call.
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

    $isFetch = $Query -is [Microsoft.Xrm.Sdk.Query.FetchExpression];
    if ($isFetch) {
        [xml]$fetchDocument = $Query.Query;
        $fetchNode = $fetchDocument.DocumentElement;
        $enablePaging = -not ($fetchNode.HasAttribute("top") -or $fetchNode.GetAttribute("aggregate") -eq "true");
    }
    else {
        $enablePaging = ($null -eq $Query.TopCount);
    }
    $pageNumber = 1;
    $pagingCookie = $null;
    if ($enablePaging -and -not $isFetch) {
        $Query.PageInfo = [Microsoft.Xrm.Sdk.Query.PagingInfo]::new();
        $Query.PageInfo.PageNumber = $pageNumber;
        $Query.PageInfo.Count = $PageSize;
        $Query.PageInfo.PagingCookie = $null;
    }

    while ($true) {
        $pageQuery = $Query;
        if ($enablePaging -and $isFetch) {
            $fetchNode.SetAttribute("page", [string]$pageNumber);
            $fetchNode.SetAttribute("count", [string]$PageSize);
            if ($pagingCookie) {
                $fetchNode.SetAttribute("paging-cookie", $pagingCookie);
            }
            else {
                $fetchNode.RemoveAttribute("paging-cookie");
            }
            $pageQuery = [Microsoft.Xrm.Sdk.Query.FetchExpression]::new($fetchDocument.OuterXml);
        }
        $results = Protect-XrmCommand -ScriptBlock { $XrmClient.RetrieveMultiple($pageQuery) };
        if ($null -eq $results) {
            break;
        }
        if ($enablePaging -and $ShowProgress) {
            Write-Progress -Activity "Retrieving data from Microsoft Dataverse" -Status "Processing record page : $pageNumber" -PercentComplete -1 -Id 1050;
        }

        & $OnPage $results;

        if ($enablePaging -and $results.MoreRecords) {
            $pageNumber++;
            if ($isFetch) {
                $pagingCookie = $results.PagingCookie;
            }
            else {
                $Query.PageInfo.PageNumber = $pageNumber;
                $Query.PageInfo.PagingCookie = $results.PagingCookie;
            }
        }
        else {
            break;
        }
    }
    if ($enablePaging -and $ShowProgress) {
        Write-Progress -Activity "Retrieving data from Microsoft Dataverse" -Id 1050 -Completed;
    }
}

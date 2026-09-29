<#
    .SYNOPSIS
    Count the rows matching a query.

    .DESCRIPTION
    Return the exact number of rows matching a QueryExpression or a FetchXml query, filters and links included.
    The count is first asked as an aggregate (countcolumn, distinct on the primary key, so a one-to-many link does not count a row twice). When the platform refuses the aggregate (more than 50,000 rows: AggregateQueryRecordLimit), the rows are paged, reading only their ids.
    Columns and orders of the query are ignored; a top / TopCount caps the result. The caller's query is not modified.
    For approximate counts of whole tables, see Get-XrmTotalRecordCount.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Query
    QueryExpression selecting the rows to count.

    .PARAMETER FetchXml
    FetchXml query selecting the rows to count.

    .PARAMETER NoAggregate
    Skip the aggregate and count by paging (for tables that refuse aggregates).

    .OUTPUTS
    System.Int64. Number of matching rows.

    .EXAMPLE
    $query = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values 0;
    $activeAccounts = Get-XrmRecordCount -XrmClient $xrmClient -Query $query;

    .EXAMPLE
    $count = Get-XrmRecordCount -XrmClient $xrmClient -FetchXml '<fetch><entity name="contact"><filter><condition attribute="parentcustomerid" operator="not-null" /></filter></entity></fetch>';

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordCount.md
#>
function Get-XrmRecordCount {
    [CmdletBinding(DefaultParameterSetName = "Query")]
    [OutputType([long])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = "Query")]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Query.QueryExpression]
        $Query,

        [Parameter(Mandatory = $true, ParameterSetName = "FetchXml")]
        [ValidateNotNullOrEmpty()]
        [String]
        $FetchXml,

        [Parameter(Mandatory = $false)]
        [switch]
        $NoAggregate
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "Query") {
            $conversionRequest = New-XrmRequest -Name "QueryExpressionToFetchXml";
            $conversionRequest | Add-XrmRequestParameter -Name "Query" -Value $Query | Out-Null;
            $FetchXml = ($XrmClient | Invoke-XrmRequest -Request $conversionRequest).Results["FetchXml"];
        }

        # Strip the query down to its filters and links
        [xml]$fetchDocument = $FetchXml;
        $fetchNode = $fetchDocument.DocumentElement;
        # Only top / TopCount caps the count: "count" and "page" come from paging (e.g. a query already run by Get-XrmMultipleRecords)
        $top = $null;
        if ($PSCmdlet.ParameterSetName -eq "Query") {
            $top = $Query.TopCount;
        }
        elseif ($fetchNode.HasAttribute("top")) {
            $top = [long]$fetchNode.GetAttribute("top");
        }
        foreach ($attributeName in @("top", "count", "page", "paging-cookie", "aggregate", "distinct", "returntotalrecordcount")) {
            $fetchNode.RemoveAttribute($attributeName);
        }
        foreach ($node in @($fetchDocument.SelectNodes("//attribute | //all-attributes | //order"))) {
            $node.ParentNode.RemoveChild($node) | Out-Null;
        }

        $entityNode = $fetchDocument.SelectSingleNode("/fetch/entity");
        $logicalName = $entityNode.GetAttribute("name");
        $primaryIdAttribute = ($XrmClient | Get-XrmEntityMetadata -LogicalName $logicalName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity)).PrimaryIdAttribute;

        $count = $null;
        if (-not $NoAggregate) {
            $aggregateDocument = $fetchDocument.Clone();
            $aggregateDocument.DocumentElement.SetAttribute("aggregate", "true");
            $countNode = $aggregateDocument.CreateElement("attribute");
            $countNode.SetAttribute("name", $primaryIdAttribute);
            $countNode.SetAttribute("alias", "pdorecordcount");
            $countNode.SetAttribute("aggregate", "countcolumn");
            $countNode.SetAttribute("distinct", "true");
            $aggregateEntityNode = $aggregateDocument.SelectSingleNode("/fetch/entity");
            $aggregateEntityNode.InsertBefore($countNode, $aggregateEntityNode.FirstChild) | Out-Null;

            try {
                $fetchExpression = [Microsoft.Xrm.Sdk.Query.FetchExpression]::new($aggregateDocument.OuterXml);
                $result = Protect-XrmCommand -ScriptBlock { $XrmClient.RetrieveMultiple($fetchExpression) };
                $count = [long]$result.Entities[0]["pdorecordcount"].Value;
            }
            catch {
                # Aggregates are refused above 50,000 rows: count by paging instead
                if ($_.Exception.Message -notmatch "AggregateQueryRecordLimit") {
                    throw;
                }
            }
        }

        if ($null -eq $count) {
            $pagedQuery = $XrmClient | Get-XrmQueryFromFetch -FetchXml $fetchDocument.OuterXml;
            $pagedQuery.ColumnSet = [Microsoft.Xrm.Sdk.Query.ColumnSet]::new($false);
            $pagedQuery.Distinct = $true;
            $pagedQuery.TopCount = $null;
            $counter = @{ Value = [long]0 };
            Invoke-XrmQueryPagesInternal -XrmClient $XrmClient -Query $pagedQuery -PageSize 5000 -OnPage {
                param($page)
                $counter.Value += $page.Entities.Count;
            };
            $count = $counter.Value;
        }

        if ($null -ne $top -and $top -lt $count) {
            $count = $top;
        }
        $count;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRecordCount -Alias *;

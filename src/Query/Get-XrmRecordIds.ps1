<#
    .SYNOPSIS
    Get the ids of the rows of a table.

    .DESCRIPTION
    Return the ids of all the rows of LogicalName, or of the rows matching Query, as a HashSet[Guid] (fast membership test with Contains).
    Only the ids are read, page by page (5,000 rows per page); the columns of the query are restored after the call.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name. Optional when Query is given.

    .PARAMETER Query
    QueryExpression selecting the rows. (Default: all rows of LogicalName)

    .OUTPUTS
    System.Collections.Generic.HashSet[Guid]. Ids of the rows.

    .EXAMPLE
    $existingIds = Get-XrmRecordIds -XrmClient $xrmClient -LogicalName "account";
    $toCreate = $sourceRows | Where-Object { -not $existingIds.Contains($_.Id) };

    .EXAMPLE
    $query = New-XrmQueryExpression -LogicalName "contact" | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values 0;
    $activeContactIds = Get-XrmRecordIds -XrmClient $xrmClient -Query $query;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordIds.md
#>
function Get-XrmRecordIds {
    [CmdletBinding(DefaultParameterSetName = "LogicalName")]
    [OutputType([System.Collections.Generic.HashSet[Guid]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true, ParameterSetName = "LogicalName")]
        [Parameter(Mandatory = $false, ParameterSetName = "Query")]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $true, ParameterSetName = "Query")]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Query.QueryExpression]
        $Query
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "LogicalName") {
            $Query = New-XrmQueryExpression -LogicalName $LogicalName;
        }
        elseif ($PSBoundParameters.ContainsKey('LogicalName') -and $Query.EntityName -ne $LogicalName) {
            throw "The query reads '$($Query.EntityName)', not '$LogicalName'.";
        }

        $ids = [System.Collections.Generic.HashSet[Guid]]::new();
        $originalColumnSet = $Query.ColumnSet;
        try {
            $Query.ColumnSet = [Microsoft.Xrm.Sdk.Query.ColumnSet]::new($false);
            Invoke-XrmQueryPagesInternal -XrmClient $XrmClient -Query $Query -PageSize 5000 -OnPage {
                param($page)
                foreach ($entity in $page.Entities) {
                    [void]$ids.Add($entity.Id);
                }
            };
        }
        finally {
            $Query.ColumnSet = $originalColumnSet;
        }
        return , $ids;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRecordIds -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmRecordIds -ParameterName "LogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

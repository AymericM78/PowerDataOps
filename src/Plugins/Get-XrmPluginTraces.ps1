<#
    .SYNOPSIS
    Retrieve plugin traces.

    .DESCRIPTION
    Get latest plugin trace log from target instance.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER ErrorOnly
    If true, filter results to return only errors. (Default: false = all traces)

    .PARAMETER Take
    Specify number of items to retrieve. (Default : 50)
#>
function Get-XrmPluginTraces {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [bool]
        $ErrorsOnly = $false,

        [Parameter(Mandatory = $false)]
        [int]
        $Take = 50
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        
        $queryTraces = New-XrmQueryExpression -LogicalName "plugintracelog" -Columns *;
        $queryTraces = $queryTraces | Add-XrmQueryOrder -Field "performanceexecutionstarttime" -OrderType Descending;
        if ($ErrorsOnly) {
            $queryTraces = $queryTraces | PowerXrm\Add-XrmQueryCondition -Field "exceptiondetails" -Condition NotNull;
        }
        $queryTraces.TopCount = $Take;
        $traces = $XrmClient | Get-XrmMultipleRecords -Query $queryTraces;

        $selectedTraces = $traces | Select-Object "performanceexecutionstarttime", "performanceexecutionduration", "operationtype", "typename", "correlationid", "depth", "mode", "messagename", "primaryentity", "plugintracelogid"  | Out-GridView -OutputMode Multiple;

        $selectedTraces | ForEach-Object {
            $fullTrace = $traces | Where-Object -Property "plugintracelogid" -EQ -Value $_.plugintracelogid;
            $fullTrace;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmPluginTraces -Alias *;
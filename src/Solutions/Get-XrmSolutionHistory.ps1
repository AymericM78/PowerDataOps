<#
    .SYNOPSIS
    Retrieve solutions history
#>
function Get-XrmSolutionHistory {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [int]
        $Take = 50
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $querySolutionHistory = New-XrmQueryExpression -LogicalName "msdyn_solutionhistory" -Columns *;
        $querySolutionHistory = $querySolutionHistory | Add-XrmQueryOrder -Field "msdyn_endtime" -OrderType Descending;
        $querySolutionHistory.TopCount = $Take;
        $solutionHistory = $XrmClient | Get-XrmMultipleRecords -Query $querySolutionHistory;
        $solutionHistory | Select-Object "msdyn_starttime", "msdyn_operation", "msdyn_suboperation", "msdyn_name", "msdyn_solutionversion", "msdyn_publishername", "msdyn_status", "msdyn_result", "msdyn_errorcode", "msdyn_endtime", "msdyn_totaltime", "msdyn_ismanaged", "msdyn_ispatch", "msdyn_isoverwritecustomizations", "msdyn_exceptionmessage", "msdyn_packagename", "msdyn_correlationid", "msdyn_activityid", "msdyn_solutionid";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmSolutionHistory -Alias *;
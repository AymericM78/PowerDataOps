<#
    .SYNOPSIS
    Retrieve workflows.

    .DESCRIPTION
    Get workflows with expected columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")
#>
function Get-XrmWorkflows {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @( "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {        
        $basicSolution = Get-XrmBasicSolution -XrmClient $XrmClient -Columns "solutionid";

        $queryProcess = New-XrmQueryExpression -LogicalName "workflow" -Columns $Columns;
        $queryProcess = $queryProcess | Add-XrmQueryCondition -Field solutionid -Condition NotEqual -Values $basicSolution.Id;
        
        $workflows = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryProcess;
        $workflows;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmWorkflows -Alias *;
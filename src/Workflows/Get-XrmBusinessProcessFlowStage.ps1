<#
    .SYNOPSIS
    Retrieve a business process flow stage.

    .DESCRIPTION
    Get a process stage record by stage name and process identifier.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER StageName
    Name of the BPF stage to retrieve.

    .PARAMETER ProcessId
    Business process flow unique identifier (workflow id).

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $stage = Get-XrmBusinessProcessFlowStage -XrmClient $xrmClient -StageName "Qualify" -ProcessId $bpfProcessId;
#>
function Get-XrmBusinessProcessFlowStage {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $StageName,

        [Parameter(Mandatory = $true)]
        [Guid]
        $ProcessId
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $query = New-XrmQueryExpression -LogicalName "processstage" -TopCount 1;
        $query = $query | Add-XrmQueryCondition -Field "processid" -Condition Equal -Values @($ProcessId);
        $query = $query | Add-XrmQueryCondition -Field "stagename" -Condition EndsWith -Values @($StageName);
        $stages = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query;

        $stage = $stages | Select-Object -First 1;
        if (-not $stage) {
            throw "Stage '$StageName' not found for process '$ProcessId'.";
        };
        $stage;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmBusinessProcessFlowStage -Alias *;

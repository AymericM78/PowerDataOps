<#
    .SYNOPSIS
    Process each object and report progress
#>
function ForEach-ObjectWithProgress {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Object[]]
        $Collection,

        [Parameter(Mandatory = $true)]
        [string]
        $OperationName,

        [Parameter(Mandatory = $false)]
        [scriptblock] 
        $ScriptBlock
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        if(-not $Collection)
        {
            return;
        }

        $current = 0;
        $total = $Collection.Count;

        if($total -eq 0)
        {
            return;
        }

        foreach($item in $Collection)
        {
            $current++;
            $percent = ($current/$total)*100;

            Write-Progress -Activity $OperationName -Status "Processing item $current of $total ($($percent.ToString('#.##')) %)..." -PercentComplete $percent;

            Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $item;
        } 
        write-progress one one -completed;
    }
    end {
        # $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function ForEach-ObjectWithProgress -Alias *;
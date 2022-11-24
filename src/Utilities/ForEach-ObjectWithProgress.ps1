<#
    .SYNOPSIS
    Process each object and report progress

    .DESCRIPTION
    Performs custom action on given collection with progress information.

    .PARAMETER Collection
    Object collection to process.

    .PARAMETER OperationName
    Name of operation to display in progress bar.

    .PARAMETER Id
    Specifies an ID that distinguishes each progress bar from the others. Use this parameter when you are creating more than one progress bar in a single command. If the progress bars do not have different IDs, they are superimposed instead of being displayed in a series.

    .PARAMETER ParentId
    Specifies the parent activity of the current activity. Use the value -1 if the current activity has no parent activity.

    .PARAMETER ProgressStep
    Define progressbar refresh (Default = 1). Set to bigger value for perf improvements on large collections.

    .PARAMETER ScriptBlock
    Custom script to apply for each object. Current object is provided as script block parameter.

    .EXAMPLE
    $items = @("1", "2", "3", "4", "5");
    ForEach-ObjectWithProgress -Collection $items -OperationName "Simply count items" -ScriptBlock {
        param($item)

        Start-Sleep -Seconds 1;
        Write-Host "Element : $item";
    }
#>
function ForEach-ObjectWithProgress {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [array]
        $Collection,

        [Parameter(Mandatory = $false)]
        [string]
        $OperationName = "Processing data...",

        [Parameter(Mandatory = $false)]
        [int]
        $Id = 0,

        [Parameter(Mandatory = $false)]
        [int]
        $ParentId = -1,

        [Parameter(Mandatory = $false)]
        [int]
        $ProgressStep = 1,

        [Parameter(Mandatory = $false)]
        [scriptblock] 
        $ScriptBlock
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        if (-not $Collection) {
            return;
        }

        $current = 0;
        $total = $Collection.Count;

        if ($total -eq 0) {
            return;
        }

        foreach ($item in $Collection) {
            $current++;
            $percent = ($current / $total) * 100;

            if($current % $ProgressStep -eq 0) {
                Write-Progress -Id $Id -ParentId $ParentId -Activity $OperationName -Status "Processing item $current of $total ($($percent.ToString('#.##')) %)..." -PercentComplete $percent;
            }
            if($item -is [Array]){
                Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList (,$item);
            }
            else {
                Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList $item;
            }
        } 
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
        Write-Progress -Activity $OperationName -Id $Id -Completed;
    }
}

Export-ModuleMember -Function ForEach-ObjectWithProgress -Alias *;
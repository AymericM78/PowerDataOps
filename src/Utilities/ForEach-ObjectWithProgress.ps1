<#
    .SYNOPSIS
    Process each object and report progress

    .DESCRIPTION
    Performs custom action on given collection with progress information.

    .PARAMETER Collection
    Object collection to process.

    .PARAMETER OperationName
    Name of operation to display in progress bar.

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
        [object[]]
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
<#
    .SYNOPSIS
    Retrieve region names.
#>
function Get-XrmRegions {
    [CmdletBinding()]
    param
    (
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $regions = @();
        $regions += "unitedstates";
        $regions += "europe";
        $regions += "asia";
        $regions += "australia";
        $regions += "india";
        $regions += "japan";
        $regions += "canada";
        $regions += "unitedkingdom";
        $regions += "unitedstatesfirstrelease";
        $regions += "southamerica";
        $regions += "france";
        $regions += "switzerland";
        $regions;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRegions -Alias *;
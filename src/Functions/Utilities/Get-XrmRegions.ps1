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
        $regions += "NorthAmerica";
        $regions += "NorthAmerica2";
        $regions += "EMEA";
        $regions += "APAC";
        $regions += "Oceania";
        $regions += "JPN";
        $regions += "SouthAmerica";
        $regions += "IND";
        $regions += "CAN";
        $regions += "UK";
        $regions += "FRANCE";
        $regions += "UAE"; #  United Arab Emirates
        $regions += "ZAF"; # South Africa
        $regions += "GER "; # Germany (Go Local) 

        $regions;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRegions -Alias *;
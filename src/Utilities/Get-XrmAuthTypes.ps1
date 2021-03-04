<#
    .SYNOPSIS
    Retrieve authentication type names.

    .DESCRIPTION
    Get available authentication types.
#>
function Get-XrmAuthTypes {
    [CmdletBinding()]
    param
    (
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        "Office365", "OAuth", "AD", "Ifd", "ClientSecret";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAuthTypes -Alias *;
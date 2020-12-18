<#
    .SYNOPSIS
    Retrieve instance 
#>
function Get-XrmInstance {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $instances = Get-XrmInstances;
        $instance = $instances | Where-Object -Property "Name" -EQ -Value $Name;
        if(-not $instance)
        {
            throw "Instance $Name not found!";
        }
        $instance;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmInstance -Alias *;
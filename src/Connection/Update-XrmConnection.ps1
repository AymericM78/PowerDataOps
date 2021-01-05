<#
    .SYNOPSIS
    Update connection settings.
#>
function Update-XrmConnection {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline = $True)]
        [Object]
        $XrmConnection
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $XrmConnection.Instances = Get-XrmInstances;
        $XrmConnection | Export-XrmConnection;        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Update-XrmConnection -Alias *;
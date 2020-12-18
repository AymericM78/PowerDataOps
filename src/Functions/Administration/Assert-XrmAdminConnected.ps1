<#
    .SYNOPSIS
    Check if current user has D365 / Dataverse admin role.
#>
function Assert-XrmAdminConnected {
    [CmdletBinding()]
    param
    (
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        # TODO : Handle admin connection with context info
        if(-not $Global:XrmContext.IsAdminConnected)
        {
            throw "You are not connected as Admin! Please use Connect-XrmAdmin command before";           
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Assert-XrmAdminConnected -Alias *;
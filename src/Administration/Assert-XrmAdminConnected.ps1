<#
    .SYNOPSIS
    Check if current user has D365 / Dataverse admin role.

    .DESCRIPTION
    This command is done each time we need to run admin operation. 
    This mean that we need to proceed to Connect-XrmAdmin before.
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

        if (-not $Global:XrmContext.IsAdminConnected) {
            throw "You are not connected as Admin! Please use Connect-XrmAdmin command before";           
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Assert-XrmAdminConnected -Alias *;
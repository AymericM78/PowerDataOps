<#
    .SYNOPSIS
    Initialize new object that represent a DevOps Connection settings.
#>
function New-XrmDevOpsSettings {
    [CmdletBinding()]
    [OutputType([PsObject])]
    param
    (
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $hash = @{ };
        $hash["OrganizationName"] = [String]::Empty;
        $hash["ProjectName"] = [String]::Empty;
        $hash["Token"] = [String]::Empty;
        
        $object = New-Object PsObject -Property $hash;
        $object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmDevOpsSettings -Alias *;
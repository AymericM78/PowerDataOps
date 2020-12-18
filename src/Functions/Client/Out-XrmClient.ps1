<#
    .SYNOPSIS
    Initialize CrmserviceClient instance from connection.
#>
function Out-XrmClient {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Tooling.Connector.CrmServiceClient")]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        $XrmInstance
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $XrmClient = New-XrmClient -ConnectionString $XrmInstance.ConnectionString;
        $XrmClient;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Out-XrmClient -Alias *;
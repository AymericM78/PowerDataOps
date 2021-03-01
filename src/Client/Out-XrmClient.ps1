<#
    .SYNOPSIS
    Initialize CrmserviceClient instance from instance object.
    
    .Description
    Create a new connection to Microsoft Dataverse from instance object.

    .PARAMETER Instance
    Microsoft Dataverse instance object.

    .OUTPUTS
    Microsoft.Xrm.Tooling.Connector.CrmServiceClient. Microsoft Dataverse connector.
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
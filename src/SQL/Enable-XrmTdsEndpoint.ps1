<#
    .SYNOPSIS
    Enable TDS endpoint.
    
    .DESCRIPTION
    Configure orgdbsettings parameter to allow SQL commands thru TDS Endpoint.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
#>
function Enable-XrmTdsEndpoint {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient

    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {            
        Set-XrmOrganizationDbSetting -XrmClient $XrmClient -Name "EnableTDSEndpoint" -Value "true";
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Enable-XrmTdsEndpoint -Alias *;
<#
    .SYNOPSIS
    Check if TDS endpoint is enabled.
    
    .DESCRIPTION
    Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
#>
function Assert-XrmTdsEndpointEnabled {
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
        $value = Get-XrmOrganizationDbSetting -XrmClient $XrmClient -Name "EnableTDSEndpoint";
        if($value -ne "true")
        {
            throw "TDS EndPoint is disabled! Please use Enable-XrmTdsEndpoint to configure it."
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Assert-XrmTdsEndpointEnabled -Alias *;
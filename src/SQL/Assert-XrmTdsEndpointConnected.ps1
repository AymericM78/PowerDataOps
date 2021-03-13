<#
    .SYNOPSIS
    Check if TDS endpoint is enabled.
    
    .DESCRIPTION
    Assert orgdbsettings EnableTDSEndpoint parameter is true to allow SQL commands thru TDS Endpoint.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
#>
function Assert-XrmTdsEndpointConnected {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient

    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);        
    }    
    process {            
       if($Global:XrmContext)
       {
           if($Global:XrmContext.CurrentConnection -and $Global:XrmContext.CurrentInstance)
           {
               if(-not [string]::IsNullOrWhiteSpace($Global:XrmContext.CurrentConnection.UserName) `
                  -and -not [string]::IsNullOrWhiteSpace($Global:XrmContext.CurrentConnection.Password) `
                  -and -not [string]::IsNullOrWhiteSpace($Global:XrmContext.CurrentInstance.Url))
               {
                   return;
               }
           }
       }

       throw "You are not connected to TDS Endpoint! Please use Connect-XrmTdsEndpoint first!"
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Assert-XrmTdsEndpointConnected -Alias *;
<#
    .SYNOPSIS
    Specify CrmserviceClient timeout.
#>
function Set-XrmClientTimeout {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,
        
        [Parameter(Mandatory = $false)]
        [Switch]
        $Revert
    )
    dynamicparam {
        $dynamicParameters = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary;
             
        # Define Dynamic Parameter : Duration
        $durationParameterAttributes = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute];
        $durationParameterAttribute = New-Object System.Management.Automation.ParameterAttribute;
        $durationParameterAttribute.Mandatory = (-not $Revert);
        $durationParameterAttributes.Add($durationParameterAttribute);       
        $durationParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter("DurationInMinutes", [int], $durationParameterAttributes);
        $dynamicParameters.Add("DurationInMinutes", $durationParameter);                       
              
        return $dynamicParameters;    
    }
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {       
        
        $durationInMinutes = $PSBoundParameters.DurationInMinutes;
        if ($durationInMinutes) {            

            if(-not $XrmClient.OrganizationServiceProxy)  {
                $Global:XrmClientInitialTimeout = $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.ReceiveTimeout.TotalMinutes;                
                
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.OpenTimeout = (New-TimeSpan -Minutes $durationInMinutes);     
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.SendTimeout = (New-TimeSpan -Minutes $durationInMinutes);  
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.ReceiveTimeout = (New-TimeSpan -Minutes $durationInMinutes);   
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.CloseTimeout = (New-TimeSpan -Minutes $durationInMinutes);   
 
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.OpenTimeout = (New-TimeSpan -Minutes $durationInMinutes);     
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.SendTimeout = (New-TimeSpan -Minutes $durationInMinutes);  
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.ReceiveTimeout = (New-TimeSpan -Minutes $durationInMinutes);   
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.CloseTimeout = (New-TimeSpan -Minutes $durationInMinutes);        
            }
            else {
                $Global:XrmClientInitialTimeout = $XrmClient.OrganizationServiceProxy.Timeout.TotalMinutes;
                $XrmClient.OrganizationServiceProxy.Timeout = (New-TimeSpan -Minutes $durationInMinutes); 
            }
        }

        if ($Revert) {
            $initialTimeOutMinutes = $Global:XrmClientInitialTimeout;

            if(-not $XrmClient.OrganizationServiceProxy)  {          
                
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.OpenTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);     
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.SendTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);  
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.ReceiveTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);   
                $XrmClient.OrganizationWebProxyClient.Endpoint.Binding.CloseTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);   
 
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.OpenTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);     
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.SendTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);  
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.ReceiveTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);   
                $XrmClient.OrganizationWebProxyClient.ChannelFactory.Endpoint.Binding.CloseTimeout = (New-TimeSpan -Minutes $initialTimeOutMinutes);               
            }
            else {
                $XrmClient.OrganizationServiceProxy.Timeout = (New-TimeSpan -Minutes $initialTimeOutMinutes); 
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmClientTimeout -Alias *;
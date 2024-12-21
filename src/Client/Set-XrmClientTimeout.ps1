<#
    .SYNOPSIS
    Specify CrmserviceClient timeout.

    .DESCRIPTION
    Extend default CrmserviceClient timeout.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER DurationInMinutes
    Timeout duration in minutes.

    .PARAMETER Revert
    Restore default timeout value.
#>
function Set-XrmClientTimeout {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
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
        # TODO : DEPRECATED
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmClientTimeout -Alias *;
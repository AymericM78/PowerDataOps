<#
    .SYNOPSIS
    Publish customizations.

    .DESCRIPTION
    Apply unpublished customizations to active layer to promote UI changes.    

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TimeOutInMinutes
    Specify timeout duration in minute. (Default : 5 min)
#>
function Publish-XrmCustomizations {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ParameterXml,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]
        $TimeOutInMinutes = 5,

        [Parameter(Mandatory = $false)]
        [bool]
        $Async = $true
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $publishRequest = New-XrmRequest -Name "PublishAllXmlAsync";
        if (-not $Async) {
            $publishRequest = New-XrmRequest -Name "PublishAllXml";
        }

        if ($ParameterXml) {
            $publishRequest = New-XrmRequest -Name "PublishXml";
            $publishRequest | Add-XrmRequestParameter -Name "ParameterXml" -Value $ParameterXml | Out-Null;
        }
        
        $response = $XrmClient | Invoke-XrmRequest -Request $publishRequest;

        if ($Async) {
            $asyncOperationId = $response.Results["AsyncOperationId"]
            Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId -TimeoutInMinutes $TimeOutInMinutes;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Publish-XrmCustomizations -Alias *;
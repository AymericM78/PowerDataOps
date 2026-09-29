<#
    .SYNOPSIS
    Publish customizations.

    .DESCRIPTION
    Apply unpublished customizations to active layer to promote UI changes.
    PublishAllXmlAsync is monitored until completion and raises an error if the publish job fails. PublishXml (ParameterXml given) and PublishAllXml (Async = false) are synchronous.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ParameterXml
    Publish only the components described by this importexportxml (PublishXml message). (Default: publish all)

    .PARAMETER TimeOutInMinutes
    Specify timeout duration in minute. (Default : 5 min)

    .PARAMETER Async
    Publish all with PublishAllXmlAsync and wait for the system job. Ignored when ParameterXml is given. (Default: true)

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Publish-XrmCustomizations -XrmClient $xrmClient;

    .EXAMPLE
    Publish-XrmCustomizations -XrmClient $xrmClient -ParameterXml "<importexportxml><entities><entity>account</entity></entities></importexportxml>";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Publish-XrmCustomizations.md
#>
function Publish-XrmCustomizations {
    [CmdletBinding()]
    [OutputType([System.Void])]
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

        if ($Async -and -not $ParameterXml) {
            $asyncOperationId = $response.Results["AsyncOperationId"];
            $XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId -TimeoutInMinutes $TimeOutInMinutes -MissingMeansSucceeded -ThrowOnFailure | Out-Null;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Publish-XrmCustomizations -Alias *;
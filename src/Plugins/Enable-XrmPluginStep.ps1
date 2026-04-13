<#
    .SYNOPSIS
    Enable a plugin step.

    .DESCRIPTION
    Activate a given SDK message processing step.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PluginStepReference
    Entity reference of the SDK message processing step to enable.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $stepRef = New-XrmEntityReference -LogicalName "sdkmessageprocessingstep" -Id $stepId;
    Enable-XrmPluginStep -PluginStepReference $stepRef;
#>
function Enable-XrmPluginStep {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $PluginStepReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        Set-XrmRecordState -XrmClient $XrmClient -RecordReference $PluginStepReference -StateCode 0 -StatusCode 1;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Enable-XrmPluginStep -Alias *;

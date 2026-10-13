<#
    .SYNOPSIS
    Disable a plugin step.

    .DESCRIPTION
    Deactivate a given SDK message processing step.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER PluginStepReference
    Entity reference of the SDK message processing step to disable.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. The plugin step reference, as returned by Set-XrmRecordState.

    .EXAMPLE
    $stepRef = New-XrmEntityReference -LogicalName "sdkmessageprocessingstep" -Id $stepId;
    Disable-XrmPluginStep -PluginStepReference $stepRef;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Disable-XrmPluginStep.md
#>
function Disable-XrmPluginStep {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
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
        Set-XrmRecordState -XrmClient $XrmClient -RecordReference $PluginStepReference -StateCode 1 -StatusCode 2;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Disable-XrmPluginStep -Alias *;

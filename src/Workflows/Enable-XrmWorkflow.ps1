<#
    .SYNOPSIS
    Enable a workflow.

    .DESCRIPTION
    Activate given workflow.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER WorkflowReference
    Entity reference of the workflow to enable.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. The workflow reference, as returned by Set-XrmRecordState.

    .EXAMPLE
    $wfRef = New-XrmEntityReference -LogicalName "workflow" -Id $workflowId;
    Enable-XrmWorkflow -WorkflowReference $wfRef;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Enable-XrmWorkflow.md
#>
function Enable-XrmWorkflow {
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
        $WorkflowReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {                
        Set-XrmRecordState -XrmClient $XrmClient -RecordReference $WorkflowReference -StateCode 1 -StatusCode 2;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Enable-XrmWorkflow -Alias *;
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
    System.Void.

    .EXAMPLE
    $wfRef = New-XrmEntityReference -LogicalName "workflow" -Id $workflowId;
    Enable-XrmWorkflow -WorkflowReference $wfRef;
#>
function Enable-XrmWorkflow {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Void])]
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
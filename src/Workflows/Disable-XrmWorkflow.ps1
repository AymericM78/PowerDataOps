<#
    .SYNOPSIS
    Disable a workflow.

    .DESCRIPTION
    Deactivate given workflow.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER WorkflowId
    Workflow unique identifier.
#>
function Disable-XrmWorkflow {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $WorkflowId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {            

        $workflowReference = New-XrmEntityReference -LogicalName "workflow" -Id $WorkflowId;

        $request = New-Object -TypeName Microsoft.Crm.Sdk.Messages.SetStateRequest;
        $request.EntityMoniker = $workflowReference;   	
        $request.State = New-XrmOptionSetValue -Value 0;
        $request.Status = New-XrmOptionSetValue -Value 1;
        
        Invoke-XrmRequest -XrmClient $XrmClient -Request $request | Out-Null;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Disable-XrmWorkflow -Alias *;
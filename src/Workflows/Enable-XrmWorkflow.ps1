<#
    .SYNOPSIS
    Enable a workflow.

    .DESCRIPTION
    Activate given workflow.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER WorkflowId
    Workflow unique identifier.
#>
function Enable-XrmWorkflow {
    [CmdletBinding()]    
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
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
        $workflowUpdate = New-XrmEntity -LogicalName "workflow" -Id $WorkflowId -Attributes @{
            "statecode" = New-XrmOptionSetValue -Value 1 
            "statuscode" = New-XrmOptionSetValue -Value 2
        }
        Update-XrmRecord -XrmClient $XrmClient -Entity $workflowUpdate;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Enable-XrmWorkflow -Alias *;
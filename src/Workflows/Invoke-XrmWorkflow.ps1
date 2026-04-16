<#
    .SYNOPSIS
    Execute a workflow on a specific record.

    .DESCRIPTION
    Trigger an on-demand workflow (classic workflow) on a target record using the ExecuteWorkflow SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER WorkflowReference
    EntityReference of the workflow to execute.

    .PARAMETER RecordReference
    EntityReference of the target record to run the workflow against.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The ExecuteWorkflow response containing AsyncOperationId.

    .EXAMPLE
    $wfRef = New-XrmEntityReference -LogicalName "workflow" -Id $workflowId;
    $recordRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
    $response = Invoke-XrmWorkflow -WorkflowReference $wfRef -RecordReference $recordRef;
    $asyncJobId = $response.Results["Id"];

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/executeworkflow
#>
function Invoke-XrmWorkflow {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $WorkflowReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RecordReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "ExecuteWorkflow";
        $request | Add-XrmRequestParameter -Name "WorkflowId" -Value $WorkflowReference.Id | Out-Null;
        $request | Add-XrmRequestParameter -Name "EntityId" -Value $RecordReference.Id | Out-Null;

        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Invoke-XrmWorkflow -Alias *;

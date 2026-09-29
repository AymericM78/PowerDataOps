<#
    .SYNOPSIS
    Delete a process (classic workflow, cloud flow, action, business rule, business process flow).

    .DESCRIPTION
    Delete a workflow row, optionally turning it off first.
    Raises an error when the process is managed (remove it by uninstalling its solution) or does not exist.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER WorkflowReference
    Reference of the process (workflow) to delete.

    .PARAMETER Deactivate
    Turn the process off before deleting it (the platform refuses to delete an activated classic workflow).

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $flow = Get-XrmWorkflows -XrmClient $xrmClient -Category 5 -Name "Old sync" | Select-Object -First 1;
    Remove-XrmWorkflow -XrmClient $xrmClient -WorkflowReference $flow.Reference -Deactivate;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmWorkflow.md
#>
function Remove-XrmWorkflow {
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
        $WorkflowReference,

        [Parameter(Mandatory = $false)]
        [switch]
        $Deactivate
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $workflow = $XrmClient | Get-XrmRecord -LogicalName "workflow" -Id $WorkflowReference.Id -Columns "name", "statecode", "ismanaged" -IfExists -AsEntity;
        if (-not $workflow) {
            throw "Process '$($WorkflowReference.Id)' not found.";
        }
        if ($workflow["ismanaged"]) {
            throw "Process '$($workflow["name"])' ($($WorkflowReference.Id)) is managed: uninstall its solution to remove it.";
        }

        if ($Deactivate -and $workflow["statecode"].Value -ne 0) {
            $XrmClient | Disable-XrmWorkflow -WorkflowReference $WorkflowReference -ErrorAction Stop | Out-Null;
        }
        $XrmClient | Remove-XrmRecord -LogicalName "workflow" -Id $WorkflowReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmWorkflow -Alias *;

<#
    .SYNOPSIS
    Delete a chart from Microsoft Dataverse.

    .DESCRIPTION
    Delete a savedqueryvisualization record (system chart).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ChartReference
    EntityReference of the savedqueryvisualization to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmChart -ChartReference $chartRef;
#>
function Remove-XrmChart {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $ChartReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Remove-XrmRecord -XrmClient $XrmClient -LogicalName "savedqueryvisualization" -Id $ChartReference.Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmChart -Alias *;

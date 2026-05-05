<#
    .SYNOPSIS
    Delete a dashboard from Microsoft Dataverse.

    .DESCRIPTION
    Delete a systemform record (dashboard). Delegates to Remove-XrmForm.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER DashboardReference
    EntityReference of the systemform (dashboard) to delete.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Remove-XrmDashboard -DashboardReference $dashRef;
#>
function Remove-XrmDashboard {
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
        $DashboardReference
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Remove-XrmForm -XrmClient $XrmClient -FormReference $DashboardReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmDashboard -Alias *;

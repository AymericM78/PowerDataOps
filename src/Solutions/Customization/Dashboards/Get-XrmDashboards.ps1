<#
    .SYNOPSIS
    Retrieve dashboard records from Microsoft Dataverse.

    .DESCRIPTION
    Get systemform records filtered to dashboards (type = 0). Delegates to Get-XrmForms.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    PSCustomObject[]. Array of systemform records (XrmObject, dashboards).

    .EXAMPLE
    $dashboards = Get-XrmDashboards;
#>
function Get-XrmDashboards {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Columns = @("*")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $dashboards = Get-XrmForms -XrmClient $XrmClient -FormType 0 -Columns $Columns;
        $dashboards;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmDashboards -Alias *;

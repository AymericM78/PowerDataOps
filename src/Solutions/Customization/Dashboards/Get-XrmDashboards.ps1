<#
    .SYNOPSIS
    Retrieve dashboard records from Microsoft Dataverse.

    .DESCRIPTION
    Get systemform records filtered to dashboards: classic dashboards (type = 0) and interactive experience dashboards (type = 10). Delegates to Get-XrmForms.
    Use -Unpublished to also retrieve dashboards that are in draft state.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER Type
    Dashboard types to return: 0 (classic dashboard), 10 (interactive experience dashboard). (Default: both)

    .PARAMETER Unpublished
    When specified, uses RetrieveUnpublishedMultiple to include dashboards in draft (unpublished) state.
    Without this switch only published dashboards are returned.

    .OUTPUTS
    PSCustomObject[]. Array of systemform records (XrmObject, dashboards).

    .EXAMPLE
    $dashboards = Get-XrmDashboards;

    .EXAMPLE
    # Include unpublished drafts
    $allDashboards = Get-XrmDashboards -Unpublished;

    .EXAMPLE
    # Classic dashboards only
    $classicDashboards = Get-XrmDashboards -Type 0;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmDashboards.md
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
        $Columns = @("*"),

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpublished,

        [Parameter(Mandatory = $false)]
        [ValidateSet(0, 10)]
        [int[]]
        $Type = @(0, 10)
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        Get-XrmForms -XrmClient $XrmClient -FormType $Type -Columns $Columns -Unpublished:$Unpublished;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmDashboards -Alias *;

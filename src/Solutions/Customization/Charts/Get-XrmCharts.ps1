<#
    .SYNOPSIS
    Retrieve chart records from Microsoft Dataverse.

    .DESCRIPTION
    Get savedqueryvisualization records (system charts) filtered by entity logical name.
    Use -Unpublished to also retrieve charts that are in draft state.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name to filter charts.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER Unpublished
    When specified, uses RetrieveUnpublishedMultiple to include charts in draft (unpublished) state.
    Without this switch only published charts are returned.

    .OUTPUTS
    PSCustomObject[]. Array of savedqueryvisualization records (XrmObject).

    .EXAMPLE
    $charts = Get-XrmCharts -EntityLogicalName "account";

    .EXAMPLE
    # Include unpublished drafts
    $allCharts = Get-XrmCharts -EntityLogicalName "account" -Unpublished;
#>
function Get-XrmCharts {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Columns = @("*"),

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpublished
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "savedqueryvisualization" -Columns $Columns;
        $query = $query | Add-XrmQueryCondition -Field "primaryentitytypecode" -Condition Equal -Values $EntityLogicalName;

        $XrmClient | Get-XrmMultipleComponents -Query $query -Unpublished:$Unpublished;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmCharts -Alias *;

<#
    .SYNOPSIS
    Retrieve multiple component records with optional unpublished support.

    .DESCRIPTION
    Executes a QueryBase against Microsoft Dataverse. When -Unpublished is specified,
    uses RetrieveUnpublishedMultiple to include draft components (forms, views, commands,
    charts, sitemaps, app modules, etc.); otherwise delegates to Get-XrmMultipleRecords
    (with full pagination support).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Query
    Query that selects and filters data from a Microsoft Dataverse table. (QueryBase)

    .PARAMETER Unpublished
    When specified, uses RetrieveUnpublishedMultiple to include components in draft
    (unpublished) state. Without this switch only published components are returned.

    .OUTPUTS
    PSCustomObject[]. Records converted to XrmObjects.

    .EXAMPLE
    $query = New-XrmQueryExpression -LogicalName "systemform" -Columns "*";
    $forms = $xrmClient | Get-XrmMultipleComponents -Query $query -Unpublished;

    .EXAMPLE
    $query = New-XrmQueryExpression -LogicalName "savedquery" -Columns "*";
    $views = $xrmClient | Get-XrmMultipleComponents -Query $query;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMultipleComponents.md
#>
function Get-XrmMultipleComponents {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.QueryBase]
        $Query,

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpublished
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($Unpublished) {
            $request = New-XrmRequest -Name "RetrieveUnpublishedMultiple";
            $request | Add-XrmRequestParameter -Name "Query" -Value $Query | Out-Null;
            $response = $XrmClient | Invoke-XrmRequest -Request $request;
            $response["EntityCollection"].Entities | ConvertTo-XrmObjects;
        }
        else {
            $XrmClient | Get-XrmMultipleRecords -Query $Query;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmMultipleComponents -Alias *;

<#
    .SYNOPSIS
    Retrieve sitemap records from Microsoft Dataverse.

    .DESCRIPTION
    Get sitemap records with optional name filter. Sitemaps define the navigation structure of model-driven apps.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Sitemap display name filter. Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    PSCustomObject[]. Array of sitemap records (XrmObject).

    .EXAMPLE
    $sitemaps = Get-XrmSiteMaps;
    $sitemap = Get-XrmSiteMaps -Name "My App SiteMap";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code
#>
function Get-XrmSiteMaps {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

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
        $query = New-XrmQueryExpression -LogicalName "sitemap" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $query = $query | Add-XrmQueryCondition -Field "sitemapname" -Condition Equal -Values $Name;
        }

        $sitemaps = $XrmClient | Get-XrmMultipleRecords -Query $query;
        $sitemaps;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmSiteMaps -Alias *;

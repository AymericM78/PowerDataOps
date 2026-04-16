<#
    .SYNOPSIS
    Update a sitemap in Microsoft Dataverse.

    .DESCRIPTION
    Update the SiteMapXml attribute of an existing sitemap record. The sitemap defines the navigation structure of a model-driven app.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SiteMapReference
    EntityReference of the sitemap record to update.

    .PARAMETER SiteMapXml
    The sitemap XML content defining Areas, Groups, and SubAreas.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $sitemaps = Get-XrmSiteMaps -Name "My SiteMap";
    $sitemapRef = $sitemaps[0].ToEntityReference();
    Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code
#>
function Set-XrmSiteMap {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $SiteMapReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteMapXml
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "sitemap";
        $record.Id = $SiteMapReference.Id;
        $record["sitemapxml"] = $SiteMapXml;

        $XrmClient | Update-XrmRecord -Record $record;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmSiteMap -Alias *;

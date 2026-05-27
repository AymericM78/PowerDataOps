<#
    .SYNOPSIS
    Update a sitemap in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing sitemap record. Supports updating the SiteMapXml content as well as navigation bar options
    (EnableCollapsibleGroups, ShowHome, ShowPinned, ShowRecents). Only provided parameters are written.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SiteMapReference
    EntityReference of the sitemap record to update.

    .PARAMETER SiteMapXml
    The sitemap XML content defining Areas, Groups, and SubAreas.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the updated sitemap is automatically added to this solution.

    .PARAMETER EnableCollapsibleGroups
    Whether navigation groups can be collapsed. Maps to the enablecollapsiblegroups attribute.

    .PARAMETER ShowHome
    Whether the Home button is shown in the navigation bar. Maps to the showhome attribute.

    .PARAMETER ShowPinned
    Whether the Pinned items section is shown in the navigation bar. Maps to the showpinned attribute.

    .PARAMETER ShowRecents
    Whether the Recent items section is shown in the navigation bar. Maps to the showrecents attribute.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $sitemaps = Get-XrmSiteMaps -Name "My SiteMap";
    $sitemapRef = $sitemaps[0].Reference;
    Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml;
    Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml -SolutionUniqueName "MySolution";

    .EXAMPLE
    Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;

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

        [Parameter(Mandatory = $false)]
        [string]
        $SiteMapXml,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $EnableCollapsibleGroups,

        [Parameter(Mandatory = $false)]
        [bool]
        $ShowHome,

        [Parameter(Mandatory = $false)]
        [bool]
        $ShowPinned,

        [Parameter(Mandatory = $false)]
        [bool]
        $ShowRecents
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "sitemap";
        $record.Id = $SiteMapReference.Id;

        if ($PSBoundParameters.ContainsKey('SiteMapXml')) { $record["sitemapxml"] = $SiteMapXml; }
        if ($PSBoundParameters.ContainsKey('EnableCollapsibleGroups')) { $record["enablecollapsiblegroups"] = $EnableCollapsibleGroups; }
        if ($PSBoundParameters.ContainsKey('ShowHome')) { $record["showhome"] = $ShowHome; }
        if ($PSBoundParameters.ContainsKey('ShowPinned')) { $record["showpinned"] = $ShowPinned; }
        if ($PSBoundParameters.ContainsKey('ShowRecents')) { $record["showrecents"] = $ShowRecents; }

        $XrmClient | Update-XrmRecord -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $SiteMapReference.Id -ComponentType 62 -DoNotIncludeSubcomponents $false | Out-Null;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmSiteMap -Alias *;

<#
    .SYNOPSIS
    Create or update a sitemap in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a sitemap record by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Sitemap Id used as the upsert key.

    .PARAMETER Name
    Display name and unique name for the sitemap.

    .PARAMETER SiteMapXml
    The sitemap XML content defining Areas, Groups, and SubAreas.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the sitemap to. Optional.

    .PARAMETER EnableCollapsibleGroups
    Whether navigation groups can be collapsed. Maps to the enablecollapsiblegroups attribute.

    .PARAMETER ShowHome
    Whether the Home button is shown in the navigation bar. Maps to the showhome attribute.

    .PARAMETER ShowPinned
    Whether the Pinned items section is shown in the navigation bar. Maps to the showpinned attribute.

    .PARAMETER ShowRecents
    Whether the Recent items section is shown in the navigation bar. Maps to the showrecents attribute.

    .PARAMETER UniqueName
    Unique name (sitemapnameunique): letters and digits only, 40 characters at most. (Default: Name without accents and without any other character than letters and digits, cut to 40)

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted sitemap record.

    .EXAMPLE
    $sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -SolutionUniqueName "MySolution";

    .EXAMPLE
    $sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
#>
function Upsert-XrmSiteMap {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
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
        $ShowRecents,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^[a-zA-Z0-9]{1,40}$')]
        [string]
        $UniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attributes = @{
            "sitemapname"       = $Name;
            "sitemapnameunique" = $(if ($PSBoundParameters.ContainsKey('UniqueName')) { $UniqueName } else { ConvertTo-XrmUniqueNameInternal -Name $Name -MaxLength 40 });
            "sitemapxml"        = $SiteMapXml;
        };

        if ($PSBoundParameters.ContainsKey('EnableCollapsibleGroups')) { $attributes["enablecollapsiblegroups"] = $EnableCollapsibleGroups; }
        if ($PSBoundParameters.ContainsKey('ShowHome')) { $attributes["showhome"] = $ShowHome; }
        if ($PSBoundParameters.ContainsKey('ShowPinned')) { $attributes["showpinned"] = $ShowPinned; }
        if ($PSBoundParameters.ContainsKey('ShowRecents')) { $attributes["showrecents"] = $ShowRecents; }

        $record = New-XrmEntity -LogicalName "sitemap" -Id $Id -Attributes $attributes;

        $XrmClient | Upsert-XrmRecord -Record $record | Out-Null;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 62 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        New-XrmEntityReference -LogicalName "sitemap" -Id $Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmSiteMap -Alias *;

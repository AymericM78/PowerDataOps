<#
    .SYNOPSIS
    Create a new sitemap in Microsoft Dataverse.

    .DESCRIPTION
    Create a new sitemap record with the given navigation XML. Sitemaps define the navigation structure of model-driven apps.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Display name for the sitemap.

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
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created sitemap record.

    .EXAMPLE
    $xml = '<SiteMap><Area Id="MyArea" Title="My Area"><Group Id="MyGroup" Title="My Group"><SubArea Id="MySub" Entity="account" /></Group></Area></SiteMap>';
    $sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml;

    .EXAMPLE
    $sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code
#>
function Add-XrmSiteMap {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

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

        $record = New-XrmEntity -LogicalName "sitemap" -Attributes $attributes;

        $record.Id = $XrmClient | Add-XrmRecord -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $record.Id -ComponentType 62 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        $record.ToEntityReference();
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmSiteMap -Alias *;

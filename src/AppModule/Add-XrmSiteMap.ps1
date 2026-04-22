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

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created sitemap record.

    .EXAMPLE
    $xml = '<SiteMap><Area Id="MyArea" Title="My Area"><Group Id="MyGroup" Title="My Group"><SubArea Id="MySub" Entity="account" /></Group></Area></SiteMap>';
    $sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml;

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
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "sitemap" -Attributes @{
            "sitemapname" = $Name;
            "sitemapxml"  = $SiteMapXml;
        };

        $record.Id = $XrmClient | Add-XrmRecord -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -SolutionUniqueName $SolutionUniqueName -ComponentId $record.Id -ComponentType 62;
        }

        $record.ToEntityReference();
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmSiteMap -Alias *;

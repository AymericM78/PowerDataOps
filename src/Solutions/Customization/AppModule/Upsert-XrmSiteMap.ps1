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

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted sitemap record.

    .EXAMPLE
    $sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -SolutionUniqueName "MySolution";
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
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attributes = @{
            "sitemapname"       = $Name;
            "sitemapnameunique" = $Name;
            "sitemapxml"        = $SiteMapXml;
        };

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

# Command : `Set-XrmSiteMap` 

## Description

**Update a sitemap in Microsoft Dataverse.** : Update an existing sitemap record. Supports updating the SiteMapXml content as well as navigation bar options (EnableCollapsibleGroups, ShowHome, ShowPinned, ShowRecents). Only provided parameters are written.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SiteMapReference|EntityReference|2|true||EntityReference of the sitemap record to update.
SiteMapXml|String|3|false||The sitemap XML content defining Areas, Groups, and SubAreas.
SolutionUniqueName|String|4|false||Unmanaged solution unique name. When provided, the updated sitemap is automatically added to this solution.
EnableCollapsibleGroups|bool|5|false||Whether navigation groups can be collapsed.
ShowHome|bool|6|false||Whether the Home button is shown in the navigation bar.
ShowPinned|bool|7|false||Whether the Pinned items section is shown in the navigation bar.
ShowRecents|bool|8|false||Whether the Recent items section is shown in the navigation bar.

## Outputs
System.Void.

## Usage

```Powershell 
Set-XrmSiteMap [[-XrmClient] <ServiceClient>] [-SiteMapReference] <EntityReference> [[-SiteMapXml] <String>] [[-SolutionUniqueName] <String>] [[-EnableCollapsibleGroups] <bool>] [[-ShowHome] <bool>] [[-ShowPinned] <bool>] [[-ShowRecents] <bool>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemaps = Get-XrmSiteMaps -Name "My SiteMap";
$sitemapRef = $sitemaps[0].Reference;
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml;
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml -SolutionUniqueName "MySolution";
``` 

```Powershell 
# Update only navigation bar options without touching the XML
Set-XrmSiteMap -SiteMapReference $sitemapRef -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code


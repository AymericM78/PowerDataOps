# Command : `Set-XrmSiteMap` 

## Description

**Update a sitemap in Microsoft Dataverse.** : Update an existing sitemap record. Supports updating the SiteMapXml content as well as navigation bar options
(EnableCollapsibleGroups, ShowHome, ShowPinned, ShowRecents). Only provided parameters are written.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SiteMapReference|EntityReference|2|true||EntityReference of the sitemap record to update.
SiteMapXml|String|3|false||The sitemap XML content defining Areas, Groups, and SubAreas.
SolutionUniqueName|String|4|false||Unmanaged solution unique name. When provided, the updated sitemap is automatically added to this solution.
EnableCollapsibleGroups|Boolean|5|false|False|Whether navigation groups can be collapsed. Maps to the enablecollapsiblegroups attribute.
ShowHome|Boolean|6|false|False|Whether the Home button is shown in the navigation bar. Maps to the showhome attribute.
ShowPinned|Boolean|7|false|False|Whether the Pinned items section is shown in the navigation bar. Maps to the showpinned attribute.
ShowRecents|Boolean|8|false|False|Whether the Recent items section is shown in the navigation bar. Maps to the showrecents attribute.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Set-XrmSiteMap [[-XrmClient] <ServiceClient>] [-SiteMapReference] <EntityReference> [[-SiteMapXml] <String>] [[-SolutionUniqueName] <String>] [[-EnableCollapsibleGroups] <Boolean>] [[-ShowHome] <Boolean>] [[-ShowPinned] <Boolean>] [[-ShowRecents] <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemaps = Get-XrmSiteMaps -Name "My SiteMap";
$sitemapRef = $sitemaps[0].Reference;
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml;
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml -SolutionUniqueName "MySolution";
``` 


```Powershell 
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



# Command : `Set-XrmSiteMap` 

## Description

**Update a sitemap in Microsoft Dataverse.** : Update the SiteMapXml attribute of an existing sitemap record. The sitemap defines the navigation structure of a model-driven app.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SiteMapReference|EntityReference|2|true||EntityReference of the sitemap record to update.
SiteMapXml|String|3|true||The sitemap XML content defining Areas, Groups, and SubAreas.
SolutionUniqueName|String|4|false||Unmanaged solution unique name. When provided, the updated sitemap is automatically added to this solution.

## Outputs
System.Void.

## Usage

```Powershell 
Set-XrmSiteMap [[-XrmClient] <ServiceClient>] [-SiteMapReference] <EntityReference> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemaps = Get-XrmSiteMaps -Name "My SiteMap";
$sitemapRef = $sitemaps[0].Reference;
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml;
Set-XrmSiteMap -SiteMapReference $sitemapRef -SiteMapXml $newXml -SolutionUniqueName "MySolution";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



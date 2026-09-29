# Command : `Upsert-XrmSiteMap` 

## Description

**Create or update a sitemap in Microsoft Dataverse.** : Upsert a sitemap record by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||Sitemap Id used as the upsert key.
Name|String|3|true||Display name and unique name for the sitemap.
SiteMapXml|String|4|true||The sitemap XML content defining Areas, Groups, and SubAreas.
SolutionUniqueName|String|5|false||Solution unique name to add the sitemap to. Optional.
EnableCollapsibleGroups|Boolean|6|false|False|Whether navigation groups can be collapsed. Maps to the enablecollapsiblegroups attribute.
ShowHome|Boolean|7|false|False|Whether the Home button is shown in the navigation bar. Maps to the showhome attribute.
ShowPinned|Boolean|8|false|False|Whether the Pinned items section is shown in the navigation bar. Maps to the showpinned attribute.
ShowRecents|Boolean|9|false|False|Whether the Recent items section is shown in the navigation bar. Maps to the showrecents attribute.
UniqueName|String|10|false||Unique name (sitemapnameunique): letters and digits only, 40 characters at most. (Default: Name without accents and without any other character than letters and digits, cut to 40)

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted sitemap record.

## Usage

```Powershell 
Upsert-XrmSiteMap [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-Name] <String> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] [[-EnableCollapsibleGroups] <Boolean>] [[-ShowHome] <Boolean>] [[-ShowPinned] <Boolean>] [[-ShowRecents] <Boolean>] [[-UniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -SolutionUniqueName "MySolution";
``` 


```Powershell 
$sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
``` 



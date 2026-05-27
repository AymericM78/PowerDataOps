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
EnableCollapsibleGroups|bool|6|false||Whether navigation groups can be collapsed.
ShowHome|bool|7|false||Whether the Home button is shown in the navigation bar.
ShowPinned|bool|8|false||Whether the Pinned items section is shown in the navigation bar.
ShowRecents|bool|9|false||Whether the Recent items section is shown in the navigation bar.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted sitemap record.

## Usage

```Powershell 
Upsert-XrmSiteMap [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-Name] <String> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] [[-EnableCollapsibleGroups] <bool>] [[-ShowHome] <bool>] [[-ShowPinned] <bool>] [[-ShowRecents] <bool>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -SolutionUniqueName "MySolution";
``` 

```Powershell 
$sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
``` 


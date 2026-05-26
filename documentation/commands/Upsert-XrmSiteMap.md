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

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted sitemap record.

## Usage

```Powershell 
Upsert-XrmSiteMap [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-Name] <String> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemapRef = Upsert-XrmSiteMap -Id $sitemapId -Name "Custom SiteMap" -SiteMapXml $xml -SolutionUniqueName "MySolution";
``` 



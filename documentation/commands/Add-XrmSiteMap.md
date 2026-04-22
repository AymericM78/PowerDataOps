# Command : `Add-XrmSiteMap` 

## Description

**Create a new sitemap in Microsoft Dataverse.** : Create a new sitemap record with the given navigation XML. Sitemaps define the navigation structure of model-driven apps.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Display name for the sitemap.
SiteMapXml|String|3|true||The sitemap XML content defining Areas, Groups, and SubAreas.
SolutionUniqueName|String|4|false||Solution unique name to add the sitemap to. Optional.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created sitemap record.

## Usage

```Powershell 
Add-XrmSiteMap [[-XrmClient] <ServiceClient>] [-Name] <String> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
<Area Id="MyArea" Title="My Area"><Group Id="MyGroup" Title="My Group"><SubArea Id="MySub" Entity="account" /></Group></Area></SiteMap>';
$sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



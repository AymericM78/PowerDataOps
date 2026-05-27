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
EnableCollapsibleGroups|bool|5|false||Whether navigation groups can be collapsed.
ShowHome|bool|6|false||Whether the Home button is shown in the navigation bar.
ShowPinned|bool|7|false||Whether the Pinned items section is shown in the navigation bar.
ShowRecents|bool|8|false||Whether the Recent items section is shown in the navigation bar.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created sitemap record.

## Usage

```Powershell 
Add-XrmSiteMap [[-XrmClient] <ServiceClient>] [-Name] <String> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] [[-EnableCollapsibleGroups] <bool>] [[-ShowHome] <bool>] [[-ShowPinned] <bool>] [[-ShowRecents] <bool>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xml = '<SiteMap><Area Id="MyArea" Title="My Area"><Group Id="MyGroup" Title="My Group"><SubArea Id="MySub" Entity="account" /></Group></Area></SiteMap>';
$sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml;
``` 

```Powershell 
$sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code


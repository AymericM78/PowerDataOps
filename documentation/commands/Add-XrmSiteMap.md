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
EnableCollapsibleGroups|Boolean|5|false|False|Whether navigation groups can be collapsed. Maps to the enablecollapsiblegroups attribute.
ShowHome|Boolean|6|false|False|Whether the Home button is shown in the navigation bar. Maps to the showhome attribute.
ShowPinned|Boolean|7|false|False|Whether the Pinned items section is shown in the navigation bar. Maps to the showpinned attribute.
ShowRecents|Boolean|8|false|False|Whether the Recent items section is shown in the navigation bar. Maps to the showrecents attribute.
UniqueName|String|9|false||Unique name (sitemapnameunique): letters and digits only, 40 characters at most. (Default: Name without accents and without any other character than letters and digits, cut to 40)
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created sitemap record.

## Usage

```Powershell 
Add-XrmSiteMap [[-XrmClient] <ServiceClient>] [-Name] <String> [-SiteMapXml] <String> [[-SolutionUniqueName] <String>] [[-EnableCollapsibleGroups] <Boolean>] [[-ShowHome] <Boolean>] [[-ShowPinned] <Boolean>] [[-ShowRecents] <Boolean>] [[-UniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
<Area Id="MyArea" Title="My Area"><Group Id="MyGroup" Title="My Group"><SubArea Id="MySub" Entity="account" /></Group></Area></SiteMap>';
$sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml;
``` 


```Powershell 
$sitemapRef = Add-XrmSiteMap -Name "Custom SiteMap" -SiteMapXml $xml -ShowHome $true -ShowPinned $true -ShowRecents $true -EnableCollapsibleGroups $false;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



# Command : `Get-XrmSiteMaps` 

## Description

**Retrieve sitemap records from Microsoft Dataverse.** : Get sitemap records with optional name filter. Sitemaps define the navigation structure of model-driven apps.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|false||Sitemap display name filter. Optional.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject[]. Array of sitemap records (XrmObject).

## Usage

```Powershell 
Get-XrmSiteMaps [[-XrmClient] <ServiceClient>] [[-Name] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$sitemaps = Get-XrmSiteMaps;
$sitemap = Get-XrmSiteMaps -Name "My App SiteMap";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



# Command : `Add-XrmAppModule` 

## Description

**Create a new model-driven app in Microsoft Dataverse.** : Create a new appmodule record (model-driven app) with the specified name and properties.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Display name for the app.
UniqueName|String|3|true||Unique name for the app (auto-prefixed with publisher prefix).
Description|String|4|false||App description. Optional.
WebResourceId|Guid|5|false||Id of the web resource to use as app icon. Optional.
PublisherReference|EntityReference|6|false||Reference to the publisher that owns the app. Optional.
ClientType|Int32|7|false|0|Client type bitmask. Optional. Common values: 1 = Web legacy, 4 = Unified Client Interface (default for new apps).
FormFactor|Int32|8|false|0|Form factor bitmask. Optional. Common values: 1 = Desktop, 2 = Tablet, 4 = Phone. Can be combined (e.g. 3 = Desktop + Tablet).
NavigationType|Int32|9|false|0|Navigation type for the app. Optional. 0 = Single session (SiteMap-based), 1 = Multi-session.
IsDefault|Boolean|10|false|False|Whether this is the default app for the organization. Optional. Defaults to false.
IsFeatured|Boolean|11|false|False|Whether the app is featured in the app picker. Optional. Defaults to false.
SolutionUniqueName|String|12|false||Solution unique name to add the app to. Optional.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created appmodule record.

## Usage

```Powershell 
Add-XrmAppModule [[-XrmClient] <ServiceClient>] [-Name] <String> [-UniqueName] <String> [[-Description] <String>] [[-WebResourceId] <Guid>] 
[[-PublisherReference] <EntityReference>] [[-ClientType] <Int32>] [[-FormFactor] <Int32>] [[-NavigationType] <Int32>] [[-IsDefault] <Boolean>] 
[[-IsFeatured] <Boolean>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Add-XrmAppModule -Name "My Custom App" -UniqueName "myapp";
``` 


```Powershell 
$pubRef = Get-XrmPublisher -PublisherUniqueName "mypublisher";
$appRef = Add-XrmAppModule -Name "My App" -UniqueName "myapp" -PublisherReference $pubRef.Reference -ClientType 4 -FormFactor 1 -NavigationType 0 -SolutionUniqueName "MySolution";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest



# Command : `Add-XrmAppModule` 

## Description

**Create a new model-driven app in Microsoft Dataverse.** : Create a new appmodule record (model-driven app) with the specified name and properties.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|named|true||Display name for the app.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "My App"; 1036 = "Mon application" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
UniqueName|String|named|true||Unique name for the app (auto-prefixed with publisher prefix).
Description|String|named|false||App description. Optional.
WebResourceId|Guid|named|false||Id of the web resource to use as app icon. Optional.
PublisherReference|EntityReference|named|false||Reference to the publisher that owns the app. Optional.
ClientType|Int32|named|false|0|Client type bitmask. Optional. Common values: 1 = Web legacy, 4 = Unified Client Interface (default for new apps).
FormFactor|Int32|named|false|0|Form factor bitmask. Optional. Common values: 1 = Desktop, 2 = Tablet, 4 = Phone. Can be combined (e.g. 3 = Desktop + Tablet).
NavigationType|Int32|named|false|0|Navigation type for the app. Optional. 0 = Single session (SiteMap-based), 1 = Multi-session.
IsDefault|Boolean|named|false|False|Whether this is the default app for the organization. Optional. Defaults to false.
IsFeatured|Boolean|named|false|False|Whether the app is featured in the app picker. Optional. Defaults to false.
SolutionUniqueName|String|named|false||Solution unique name to add the app to. Optional.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created appmodule record.

## Usage

```Powershell 
Add-XrmAppModule [-XrmClient <ServiceClient>] -Name <String> [-LanguageCode <Int32>] -UniqueName <String> [-Description <String>] [-WebResourceId <Guid>] [-PublisherReference <EntityReference>] [-ClientType <Int32>] [-FormFactor <Int32>] [-NavigationType <Int32>] [-IsDefault <Boolean>] [-IsFeatured <Boolean>] [-SolutionUniqueName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]

Add-XrmAppModule [-XrmClient <ServiceClient>] -Labels <Hashtable> [-LanguageCode <Int32>] -UniqueName <String> [-Description <String>] [-WebResourceId <Guid>] [-PublisherReference <EntityReference>] [-ClientType <Int32>] [-FormFactor <Int32>] [-NavigationType <Int32>] [-IsDefault <Boolean>] [-IsFeatured <Boolean>] [-SolutionUniqueName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Add-XrmAppModule -Name "My Custom App" -UniqueName "myapp";
``` 


```Powershell 
$pubRef = Get-XrmPublisher -PublisherUniqueName "mypublisher";
$appRef = Add-XrmAppModule -Name "My App" -UniqueName "myapp" -PublisherReference $pubRef.Reference -ClientType 4 -FormFactor 1 -NavigationType 0 -SolutionUniqueName "MySolution";
``` 


```Powershell 
$appRef = Add-XrmAppModule -Labels @{ 1033 = "My App"; 1036 = "Mon application" } -LanguageCode 1036 -UniqueName "myapp";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest



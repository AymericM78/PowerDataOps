# Command : `Upsert-XrmAppModule` 

## Description

**Create or update a model-driven app in Microsoft Dataverse.** : Create or update an appmodule record by Id: when the app exists, published or not (a new app stays unpublished until it is published), it is updated; otherwise it is created with the provided Id.
The SDK Upsert message is not used: it does not see unpublished apps and tries to create them again.
With -Labels, the name is also set in each language (SetLocLabels).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||App (appmodule) Id used as the upsert key.
Name|String|named|true||Display name for the app.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and each language is set as a translation. Example: @{ 1033 = "My App"; 1036 = "Mon application" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
UniqueName|String|named|true||Unique name for the app.
Description|String|named|false||App description. Optional.
WebResourceId|Guid|named|false||Id of the web resource to use as app icon. Optional.
PublisherReference|EntityReference|named|false||Reference to the publisher that owns the app. Optional.
ClientType|Int32|named|false|0|Client type bitmask. Optional.
FormFactor|Int32|named|false|0|Form factor bitmask. Optional.
NavigationType|Int32|named|false|0|Navigation type for the app. Optional.
IsDefault|Boolean|named|false|False|Whether this is the default app for the organization. Optional.
IsFeatured|Boolean|named|false|False|Whether the app is featured in the app picker. Optional.
SolutionUniqueName|String|named|false||Solution unique name to add the app to. Optional.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted appmodule record.

## Usage

```Powershell 
Upsert-XrmAppModule [-XrmClient <ServiceClient>] -Id <Guid> -Name <String> [-LanguageCode <Int32>] -UniqueName <String> [-Description <String>] [-WebResourceId <Guid>] [-PublisherReference <EntityReference>] [-ClientType <Int32>] [-FormFactor <Int32>] [-NavigationType <Int32>] [-IsDefault <Boolean>] [-IsFeatured <Boolean>] [-SolutionUniqueName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]

Upsert-XrmAppModule [-XrmClient <ServiceClient>] -Id <Guid> -Labels <Hashtable> [-LanguageCode <Int32>] -UniqueName <String> [-Description <String>] [-WebResourceId <Guid>] [-PublisherReference <EntityReference>] [-ClientType <Int32>] [-FormFactor <Int32>] [-NavigationType <Int32>] [-IsDefault <Boolean>] [-IsFeatured <Boolean>] [-SolutionUniqueName <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Upsert-XrmAppModule -Id $appId -Name "My Custom App" -UniqueName "myapp" -SolutionUniqueName "MySolution";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmAppModule.md



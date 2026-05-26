# Command : `Upsert-XrmAppModule` 

## Description

**Create or update a model-driven app in Microsoft Dataverse.** : Upsert an appmodule record by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||App (appmodule) Id used as the upsert key.
Name|String|3|true||Display name for the app.
UniqueName|String|4|true||Unique name for the app.
Description|String|5|false||App description. Optional.
WebResourceId|Guid|6|false||Id of the web resource to use as app icon. Optional.
PublisherReference|EntityReference|7|false||Reference to the publisher that owns the app. Optional.
ClientType|Int32|8|false|0|Client type bitmask. Optional.
FormFactor|Int32|9|false|0|Form factor bitmask. Optional.
NavigationType|Int32|10|false|0|Navigation type for the app. Optional.
IsDefault|Boolean|11|false|False|Whether this is the default app for the organization. Optional.
IsFeatured|Boolean|12|false|False|Whether the app is featured in the app picker. Optional.
SolutionUniqueName|String|13|false||Solution unique name to add the app to. Optional.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted appmodule record.

## Usage

```Powershell 
Upsert-XrmAppModule [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-Name] <String> [-UniqueName] <String> [[-Description] <String>] [[-WebResourceId] 
<Guid>] [[-PublisherReference] <EntityReference>] [[-ClientType] <Int32>] [[-FormFactor] <Int32>] [[-NavigationType] <Int32>] [[-IsDefault] <Boolean>] 
[[-IsFeatured] <Boolean>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Upsert-XrmAppModule -Id $appId -Name "My Custom App" -UniqueName "myapp" -SolutionUniqueName "MySolution";
``` 



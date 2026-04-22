# Command : `Set-XrmAppModule` 

## Description

**Update a model-driven app in Microsoft Dataverse.** : Update appmodule record properties (name, description, icon).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||EntityReference of the appmodule record to update.
Name|String|3|false||New display name. Optional.
Description|String|4|false||New description. Optional.
WebResourceId|Guid|5|false||New web resource icon Id. Optional.

## Outputs
System.Void.

## Usage

```Powershell 
Set-XrmAppModule [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [[-Name] <String>] [[-Description] <String>] [[-WebResourceId] 
<Guid>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmAppModule -AppModuleReference $appRef -Name "Renamed App" -Description "Updated description";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



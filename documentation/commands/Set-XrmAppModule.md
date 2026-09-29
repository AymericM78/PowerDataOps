# Command : `Set-XrmAppModule` 

## Description

**Update a model-driven app in Microsoft Dataverse.** : Update appmodule record properties (name, description, icon).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||EntityReference of the appmodule record to update.
Name|String|3|false||New display name. Optional.
Labels|Hashtable|4|false||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and each language is set as a translation (SetLocLabels). -Name takes precedence for the stored name if both are provided.
LanguageCode|Int32|5|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
Description|String|6|false||New description. Optional.
WebResourceId|Guid|7|false||New web resource icon Id. Optional.
SolutionUniqueName|String|8|false||Unmanaged solution unique name. When provided, the updated app is automatically added to this solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Set-XrmAppModule [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [[-Name] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] [[-Description] <String>] [[-WebResourceId] <Guid>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmAppModule -AppModuleReference $appRef -Name "Renamed App" -Description "Updated description";
Set-XrmAppModule -AppModuleReference $appRef -Name "Renamed App" -SolutionUniqueName "MySolution";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAppModule.md



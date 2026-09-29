# Command : `Remove-XrmAppModule` 

## Description

**Delete a model-driven app from Microsoft Dataverse.** : Remove an appmodule record (model-driven app).
Publishing an app makes the platform add Dataverse search rows (dvtablesearch) for it: M365_Primary_model_<unique name>, which prevents the app deletion, and new_dvtablesearch_aiplugin_model_<unique name>, which the app deletion leaves behind. These rows are deleted first.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||EntityReference of the appmodule record to delete.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmAppModule [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmAppModule -AppModuleReference $appRef;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmAppModule.md



# Command : `Remove-XrmPluginAssembly` 

## Description

**Delete a plug-in assembly with its steps and plug-in types.** : Delete the steps of the assembly (their images go with them), then its plug-in types, then the assembly itself.
Without Force, raises an error when the assembly still has steps, and deletes nothing.
Raises an error, before deleting anything, when the assembly is managed (remove it by uninstalling its solution) or does not exist.
A plug-in type used by a custom API or a custom workflow activity cannot be deleted: the platform error is raised and the assembly is kept.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Plug-in assembly name (pluginassembly.name, without version).
Force|SwitchParameter|named|false|False|Delete the steps registered on the assembly first.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
PSCustomObject. AssemblyId, StepsRemoved, TypesRemoved.

## Usage

```Powershell 
Remove-XrmPluginAssembly [[-XrmClient] <ServiceClient>] [-Name] <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmPluginAssembly -XrmClient $xrmClient -Name "Contoso.Plugins.Legacy" -Force;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmPluginAssembly.md



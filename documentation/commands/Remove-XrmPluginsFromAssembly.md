# Command : `Remove-XrmPluginsFromAssembly` 

## Description

**Remove Plugins Steps and Types From Assembly.** : Uninstall all steps and types from plugin assembly.
Only the steps with a rank above 0 and the plug-in types without steps (workflow activities excluded) are removed, and the assembly is kept: to delete an assembly with all its steps and types, use Remove-XrmPluginAssembly -Force.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AssemblyName|String|2|false|Plugins|Name of assembly where plugin will be removed. (Default : Plugins)
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||


## Usage

```Powershell 
Remove-XrmPluginsFromAssembly [[-XrmClient] <ServiceClient>] [[-AssemblyName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 



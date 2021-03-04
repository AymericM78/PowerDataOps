# Command : `Remove-XrmPluginsFromAssembly` 

## Description

**Remove Plugins Steps and Types From Assembly.** : Uninstall all steps and types from plugin assembly.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
AssemblyName|String|2|false|Plugins|Name of assembly where plugin will be removed. (Default : Plugins)


## Usage

```Powershell 
Remove-XrmPluginsFromAssembly [[-XrmClient] <CrmServiceClient>] [[-AssemblyName] <String>] [<CommonParameters>]
``` 



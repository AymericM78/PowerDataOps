# Command : `Get-XrmPluginSteps` 

## Description

**Retrieve plug-in steps (SDK message processing steps).** : Get sdkmessageprocessingstep rows, optionally filtered by assembly, table, message and state.
Each row also carries AssemblyName, PluginTypeName, MessageName and EntityLogicalName ("none" for a message that is not bound to a table).
CustomOnly keeps the steps registered by customers or partners: visible steps (ishidden false, customizationlevel 1) whose plug-in assembly name does not start with "Microsoft.". The platform refuses to modify the steps registered by Microsoft.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AssemblyName|String|2|false||Plug-in assembly name (pluginassembly.name, without version). (Default: all)
EntityLogicalName|String|3|false||Table logical name of the step filter (e.g. "account"). (Default: all)
MessageName|String|4|false||SDK message name (e.g. "Create", "Update"). (Default: all)
ActiveOnly|SwitchParameter|named|false|False|Keep the enabled steps only.
CustomOnly|SwitchParameter|named|false|False|Keep the steps registered by customers or partners only (see description).
Columns|String[]|5|false|@("name", "stage", "mode", "rank", "statecode", "filteringattributes", "eventhandler", "sdkmessageid", "sdkmessagefilterid", "ismanaged", "customizationlevel", "ishidden")|Step columns to return. (Default: name, stage, mode, rank, statecode, filteringattributes, eventhandler, sdkmessageid, sdkmessagefilterid, ismanaged, customizationlevel, ishidden)

## Outputs
PSCustomObject[]. Step rows (XrmObject) with AssemblyName, PluginTypeName, MessageName and EntityLogicalName.

## Usage

```Powershell 
Get-XrmPluginSteps [[-XrmClient] <ServiceClient>] [[-AssemblyName] <String>] [[-EntityLogicalName] <String>] [[-MessageName] <String>] [-ActiveOnly] [-CustomOnly] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$steps = Get-XrmPluginSteps -XrmClient $xrmClient -EntityLogicalName "account" -MessageName "Update" -ActiveOnly -CustomOnly;
$steps | Select-Object name, PluginTypeName, stage, rank;
``` 


```Powershell 
# Disable the steps of an assembly before a data migration
Get-XrmPluginSteps -XrmClient $xrmClient -AssemblyName "Contoso.Plugins" -ActiveOnly | ForEach-Object { Disable-XrmPluginStep -XrmClient $xrmClient -PluginStepReference $_.Reference };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPluginSteps.md



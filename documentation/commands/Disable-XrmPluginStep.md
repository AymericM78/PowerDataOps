# Command : `Disable-XrmPluginStep` 

## Description

**Disable a plugin step.** : Deactivate a given SDK message processing step.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PluginStepReference|EntityReference|2|true||Entity reference of the SDK message processing step to disable.

## Outputs
System.Void.

## Usage

```Powershell 
Disable-XrmPluginStep [[-XrmClient] <ServiceClient>] [-PluginStepReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$stepRef = New-XrmEntityReference -LogicalName "sdkmessageprocessingstep" -Id $stepId;
Disable-XrmPluginStep -PluginStepReference $stepRef;
``` 



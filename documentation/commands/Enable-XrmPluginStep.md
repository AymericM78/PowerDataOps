# Command : `Enable-XrmPluginStep` 

## Description

**Enable a plugin step.** : Activate a given SDK message processing step.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
PluginStepReference|EntityReference|2|true||Entity reference of the SDK message processing step to enable.

## Outputs
System.Void.

## Usage

```Powershell 
Enable-XrmPluginStep [[-XrmClient] <ServiceClient>] [-PluginStepReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$stepRef = New-XrmEntityReference -LogicalName "sdkmessageprocessingstep" -Id $stepId;
Enable-XrmPluginStep -PluginStepReference $stepRef;
``` 



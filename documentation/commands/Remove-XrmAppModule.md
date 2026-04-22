# Command : `Remove-XrmAppModule` 

## Description

**Delete a model-driven app from Microsoft Dataverse.** : Remove an appmodule record (model-driven app).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||EntityReference of the appmodule record to delete.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmAppModule [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmAppModule -AppModuleReference $appRef;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code



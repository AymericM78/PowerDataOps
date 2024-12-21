# Command : `Remove-XrmActiveCustomizations` 

## Description

**Remove active customizations.** : Performs a cleaning on Active Layer to remove unmanaged customizations for given component.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionComponentName|String|2|true||
ComponentId|Guid|3|true||Solution component unique identifier to clean.


## Usage

```Powershell 
Remove-XrmActiveCustomizations [[-XrmClient] <ServiceClient>] [-SolutionComponentName] <String> [-ComponentId] <Guid> [<CommonParameters>]
``` 



# Command : `Remove-XrmActiveCustomizations` 

## Description

**Remove active customizations.** : Performs a cleaning on Active Layer to remove unmanaged customizations for given component.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionComponentName|String|2|true||
ComponentId|Guid|3|true||Solution component unique identifier to clean.


## Usage

```Powershell 
Remove-XrmActiveCustomizations [[-XrmClient] <CrmServiceClient>] [-SolutionComponentName] <String> [-ComponentId] 
<Guid> [<CommonParameters>]
``` 



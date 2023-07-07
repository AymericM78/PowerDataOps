# Command : `Clear-XrmActiveCustomizations` 

## Description

**Clear active customizations for given solution components.** : Performs a cleaning on Active Layer to remove unmanaged customizations for given component types.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionUniqueName|String|2|true||Solution unique name where to get components to clean.
ComponentTypes|Int32[]|3|false|@(26, 59, 60, 61, 62, 300)|Solution components types number to clean. (Default = 26, 59, 60, 61, 62, 300 = SavedQuery, SavedQueryVisualization, SystemForm, WebResource, SiteMap, Canvas App)


## Usage

```Powershell 
Clear-XrmActiveCustomizations [[-XrmClient] <CrmServiceClient>] [-SolutionUniqueName] <String> [[-ComponentTypes] <Int32[]>] 
[<CommonParameters>]
``` 



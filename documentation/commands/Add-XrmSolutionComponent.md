# Command : `Add-XrmSolutionComponent` 

## Description

**Add Solution Component.** : Add given component to specified solution.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionUniqueName|String|2|true||Unmanaged solution unique name where to add component.
ComponentId|Guid|3|true||Component unique identifier.
ComponentType|Int32|4|true|0|Component type number (see Get-XrmSolutionComponentName to get name from type number).
DoNotIncludeSubcomponents|Boolean|5|false|True|Indicates whether the subcomponents should be included. (Default : true = no subcomponents)
AddRequiredComponents|Boolean|6|false|False|Gets or sets a value that indicates whether other solution components that are required by the solution component that you are adding should also be added to the unmanaged solution. Required. (Default : false = do not add required components)


## Usage

```Powershell 
Add-XrmSolutionComponent [[-XrmClient] <CrmServiceClient>] [-SolutionUniqueName] <String> [-ComponentId] <Guid> [-ComponentType] <Int32> [[-DoNotIncludeSubcomponents] 
<Boolean>] [[-AddRequiredComponents] <Boolean>] [<CommonParameters>]
``` 



# Command : `Add-XrmSolutionComponents` 

## Description

**Add multiple components to a solution.** : Adds a batch of components to the specified unmanaged solution and returns
one result object per component.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Unmanaged solution unique name where components are added.
Components|Object[]|3|true||Collection of component descriptors. Supported input shapes:
- @{ ComponentId = <Guid>; ComponentType = <int> }
- solutioncomponent rows with objectid and componenttype/componenttype_Value
DoNotIncludeSubcomponents|Boolean|4|false|True|Indicates whether subcomponents should be included. Default: true.
AddRequiredComponents|Boolean|5|false|False|Indicates whether required components should be included. Default: false.
ContinueOnError|Boolean|6|false|True|Continue processing remaining components when one component fails. Default: true.

## Outputs
PSCustomObject array.

## Usage

```Powershell 
Add-XrmSolutionComponents [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-Components] <Object[]> [[-DoNotIncludeSubcomponents] <Boolean>] 
[[-AddRequiredComponents] <Boolean>] [[-ContinueOnError] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$components = @(
[pscustomobject]@{ ComponentId = $entityId; ComponentType = 1 },
    [pscustomobject]@{ ComponentId = $viewId; ComponentType = 26 }
);
Add-XrmSolutionComponents -SolutionUniqueName "MySolution" -Components $components;
``` 



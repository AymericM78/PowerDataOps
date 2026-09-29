# Command : `Move-XrmSolutionComponent` 

## Description

**Move a component from one unmanaged solution to another.** : Add the component to the target solution, check that it is there, then remove it from the source solution.
The component itself is not changed: only its membership moves.
Raises an error, before any change, when the component is not in the source solution; and, before removing it from the source, when the target solution does not list it after the addition.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SourceSolutionUniqueName|String|2|true||Unmanaged solution the component leaves.
TargetSolutionUniqueName|String|3|true||Unmanaged solution the component joins.
ComponentId|Guid|4|true||Component unique identifier (objectid).
ComponentType|Int32|5|true|0|Solution component type code (see Get-XrmSolutionComponentType).
DoNotIncludeSubcomponents|Boolean|6|false|False|Passed to Add-XrmSolutionComponent. (Default: true for a table, false otherwise)
AddRequiredComponents|Boolean|7|false|False|Passed to Add-XrmSolutionComponent. (Default: false)
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
PSCustomObject. ComponentId, ComponentType, SourceSolutionUniqueName, TargetSolutionUniqueName.

## Usage

```Powershell 
Move-XrmSolutionComponent [[-XrmClient] <ServiceClient>] [-SourceSolutionUniqueName] <String> [-TargetSolutionUniqueName] <String> [-ComponentId] <Guid> [-ComponentType] <Int32> [[-DoNotIncludeSubcomponents] <Boolean>] [[-AddRequiredComponents] <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Move-XrmSolutionComponent -XrmClient $xrmClient -From "Staging" -To "Core" -ComponentId $viewId -ComponentType 26;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Move-XrmSolutionComponent.md



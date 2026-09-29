# Command : `Test-XrmSolutionComponent` 

## Description

**Check whether a component belongs to a solution.** : Look for the component in the solution components (solutioncomponent) of the given solution.
Raises an error when the solution does not exist.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name.
ComponentId|Guid|3|true||Component unique identifier (objectid: the MetadataId for tables and columns, the row id for the other components).
ComponentType|Int32|4|true|0|Solution component type code (see Get-XrmSolutionComponentType).

## Outputs
System.Boolean. True when the component is in the solution.

## Usage

```Powershell 
Test-XrmSolutionComponent [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-ComponentId] <Guid> [-ComponentType] <Int32> [<CommonParameters>]
``` 

## Examples

```Powershell 
$viewType = Get-XrmSolutionComponentType -XrmClient $xrmClient -LogicalName "savedquery";
if (-not (Test-XrmSolutionComponent -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentId $viewId -ComponentType $viewType)) {
    Add-XrmSolutionComponent -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentId $viewId -ComponentType $viewType;
}
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmSolutionComponent.md



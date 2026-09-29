# Command : `Get-XrmComponentDependencies` 

## Description

**Retrieve the dependencies of a solution component.** : Ask the platform which components depend on a component, or which components it requires:
- ForDelete (RetrieveDependenciesForDelete): the components that prevent deleting it;
- Dependent (RetrieveDependentComponents): every component that depends on it;
- Required (RetrieveRequiredComponents): the components it requires.
Each row carries dependentcomponentobjectid, dependentcomponenttype, requiredcomponentobjectid, requiredcomponenttype, dependencytype, plus DependentComponentTypeName and RequiredComponentTypeName (see Get-XrmSolutionComponentName).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ComponentId|Guid|2|true||Component unique identifier (objectid: the MetadataId for tables and columns, the row id for the other components).
ComponentType|Int32|3|true|0|Solution component type code (see Get-XrmSolutionComponentType).
Kind|String|4|false|ForDelete|ForDelete, Dependent or Required. (Default: ForDelete)

## Outputs
PSCustomObject[]. Dependency rows (XrmObject).

## Usage

```Powershell 
Get-XrmComponentDependencies [[-XrmClient] <ServiceClient>] [-ComponentId] <Guid> [-ComponentType] <Int32> [[-Kind] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$table = Get-XrmEntityMetadata -XrmClient $xrmClient -LogicalName "new_project" -Filter Entity;
$blocking = Get-XrmComponentDependencies -XrmClient $xrmClient -ComponentId $table.MetadataId -ComponentType 1 -Kind ForDelete;
$blocking | Select-Object DependentComponentTypeName, dependentcomponentobjectid;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmComponentDependencies.md



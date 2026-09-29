# Command : `Get-XrmSolutionComponentType` 

## Description

**Get the solution component type code of a table or a component name.** : Return the solution component type code to use with Add-XrmSolutionComponent and friends.
The organization is asked first (solutioncomponentdefinition): the code of the components brought by solution-aware tables (connection references, custom APIs...) depends on the organization.
For the classic components, which solutioncomponentdefinition does not list (views, forms, web resources, app modules...), a fixed table is used.
Raises an error when the type is unknown.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|named|true||Logical name of the table holding the component (e.g. "connectionreference", "savedquery", "webresource").
Name|String|named|true||Component type name (e.g. "SavedQuery", "connectionreference"), as returned by Get-XrmSolutionComponentName.
Cache|Hashtable|named|false||Hashtable owned by the caller, used to store and reuse the codes read from the organization. (Default: no cache)

## Outputs
System.Int32. Solution component type code.

## Usage

```Powershell 
Get-XrmSolutionComponentType [-XrmClient <ServiceClient>] -LogicalName <String> [-Cache <Hashtable>] [<CommonParameters>]

Get-XrmSolutionComponentType [-XrmClient <ServiceClient>] -Name <String> [-Cache <Hashtable>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$type = Get-XrmSolutionComponentType -XrmClient $xrmClient -LogicalName "connectionreference";
Add-XrmSolutionComponent -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentId $referenceId -ComponentType $type;
``` 


```Powershell 
$cache = @{};
$viewType = Get-XrmSolutionComponentType -XrmClient $xrmClient -LogicalName "savedquery" -Cache $cache;   # 26
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponentType.md



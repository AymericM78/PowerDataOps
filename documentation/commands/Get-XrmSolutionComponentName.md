# Command : `Get-XrmSolutionComponentName` 

## Description

**Get Solution Component name from Id.** : Retrieve component name from its number.
Classic component types come from a fixed table. The types added by solution-aware tables (connection references, custom APIs, environment variables...) depend on the organization: when XrmClient is available they are read from solutioncomponentdefinition.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
SolutionComponentType|Int32|1|true|0|Solution component type number.
XrmClient|ServiceClient|2|false|$Global:XrmClient|Xrm connector initialized to target instance, used for the types that are not in the fixed table. Use latest one by default. (Dataverse ServiceClient)
Cache|Hashtable|3|false||Hashtable owned by the caller, used to store and reuse the names read from the organization. (Default: no cache)

## Outputs
System.String. Component type name.

## Usage

```Powershell 
Get-XrmSolutionComponentName [-SolutionComponentType] <Int32> [[-XrmClient] <ServiceClient>] [[-Cache] <Hashtable>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$name = Get-XrmSolutionComponentName -SolutionComponentType 26;   # SavedQuery
``` 


```Powershell 
$name = Get-XrmSolutionComponentName -SolutionComponentType $component.componenttype_Value.Value -XrmClient $xrmClient;
``` 

## More informations

https://docs.microsoft.com/en-us/dynamics365/customer-engagement/web-api/solutioncomponent?view=dynamics-ce-odata-9



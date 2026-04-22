# Command : `Get-XrmCustomizedSolutionComponents` 

## Description

**Get customized solution components from Active layer.** : Retrieves solution components from a solution, then keeps only components
with meaningful Active-layer customizations.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Unmanaged solution unique name where to inspect components.
ComponentTypes|Int32[]|3|false|@()|Solution component types to inspect. Default: inspect all component types in solution.
ExcludedProperties|String[]|4|false|@("displaymask", "createdon", "modifiedon", "attributetypeid", "attributelogicaltypeid")|Changed properties to ignore when evaluating meaningful customizations.
IncludedProperties|String[]|5|false|@()|If provided, only these changed properties are evaluated.
IncludeDetails|SwitchParameter|named|false|False|Include changed properties and layer metadata in output.

## Outputs
PSCustomObject array.

## Usage

```Powershell 
Get-XrmCustomizedSolutionComponents [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [[-ComponentTypes] <Int32[]>] [[-ExcludedProperties] 
<String[]>] [[-IncludedProperties] <String[]>] [-IncludeDetails] [<CommonParameters>]
``` 

## Examples

```Powershell 
$components = Get-XrmCustomizedSolutionComponents -SolutionUniqueName "MySolution";
``` 


```Powershell 
$components = Get-XrmCustomizedSolutionComponents -SolutionUniqueName "MySolution" -ComponentTypes @(60, 26) -IncludeDetails;
``` 



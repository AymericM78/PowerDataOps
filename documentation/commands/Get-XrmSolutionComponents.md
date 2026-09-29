# Command : `Get-XrmSolutionComponents` 

## Description

**Get Solution Components.** : Retrieve components from given solution and expected types.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Unmanaged solution unique name where to get components.
ComponentTypes|Int32[]|3|false|@()|Array of component types number to retrieve. (Default: none = retrieve all components)
IfExists|SwitchParameter|named|false|False|Return $null silently when the solution does not exist. Without it, a FAIL line is logged before returning $null.

## Outputs
PSCustomObject[]. Solution component rows (XrmObject) with objectid and componenttype.

## Usage

```Powershell 
Get-XrmSolutionComponents [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [[-ComponentTypes] <Int32[]>] [-IfExists] [<CommonParameters>]
``` 

## Examples

```Powershell 
$views = Get-XrmSolutionComponents -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentTypes 26;
``` 


```Powershell 
$components = Get-XrmSolutionComponents -XrmClient $xrmClient -SolutionUniqueName "MaybeThere" -IfExists;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmSolutionComponents.md



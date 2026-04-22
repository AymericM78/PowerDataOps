# Command : `Test-XrmSolution` 

## Description

**Verify whether a Dataverse solution exists.** : Return $true when a solution exists for the specified unique name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to check.

## Outputs
System.Boolean.

## Usage

```Powershell 
Test-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Test-XrmSolution -SolutionUniqueName "contoso_core";
``` 



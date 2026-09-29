# Command : `Test-XrmSolution` 

## Description

**Verify whether a Dataverse solution exists.** : Return $true when a solution exists for the specified unique name.
With Managed, return $true only when the solution exists and is managed; with Unmanaged, only when it exists and is unmanaged.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to check.
Managed|SwitchParameter|named|false|False|Also require the solution to be managed.
Unmanaged|SwitchParameter|named|false|False|Also require the solution to be unmanaged.

## Outputs
System.Boolean.

## Usage

```Powershell 
Test-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-Managed] [-Unmanaged] [<CommonParameters>]
``` 

## Examples

```Powershell 
Test-XrmSolution -SolutionUniqueName "contoso_core";
``` 


```Powershell 
if (Test-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_core" -Managed) { Write-Host "Installed as managed"; }
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmSolution.md



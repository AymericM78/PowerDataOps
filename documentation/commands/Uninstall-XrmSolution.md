# Command : `Uninstall-XrmSolution` 

## Description

**Uninstall a solution from Microsoft Dataverse.** : Delete a solution (managed or unmanaged) from the environment by its unique name.
Uses the UninstallSolutionAsync SDK message to avoid timeout issues, then monitors
the async operation via Watch-XrmAsynchOperation until completion.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to uninstall.

## Outputs
System.Void.

## Usage

```Powershell 
Uninstall-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Uninstall-XrmSolution -SolutionUniqueName "contoso_crm";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/uninstall-delete-solution



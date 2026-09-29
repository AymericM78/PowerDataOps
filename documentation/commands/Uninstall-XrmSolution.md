# Command : `Uninstall-XrmSolution` 

## Description

**Uninstall a solution from Microsoft Dataverse.** : Delete a solution (managed or unmanaged) from the environment by its unique name.
Uses the UninstallSolutionAsync SDK message to avoid timeout issues, then monitors
the async operation via Watch-XrmAsynchOperation until completion.
Raises an error when the uninstall system job fails or is canceled.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to uninstall.
PassThru|SwitchParameter|named|false|False|Return the status of the uninstall system job (see Watch-XrmAsynchOperation). (Default: nothing is returned)

## Outputs
PSCustomObject. With PassThru only: Id, StatusCode, Status, Message, FriendlyMessage of the uninstall system job.

## Usage

```Powershell 
Uninstall-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-PassThru] [<CommonParameters>]
``` 

## Examples

```Powershell 
Uninstall-XrmSolution -SolutionUniqueName "contoso_crm";
``` 


```Powershell 
$status = Uninstall-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_crm" -PassThru;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/uninstall-delete-solution



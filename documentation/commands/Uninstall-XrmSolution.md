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
OnlyIfEmpty|SwitchParameter|named|false|False|Keep the solution, without error, when it still has components (an unmanaged solution used as a container).
IfExists|SwitchParameter|named|false|False|Do nothing, without error, when the solution does not exist.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
PSCustomObject. With PassThru only: Id, StatusCode, Status, Message, FriendlyMessage of the uninstall system job.

## Usage

```Powershell 
Uninstall-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-PassThru] [-OnlyIfEmpty] [-IfExists] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Uninstall-XrmSolution -SolutionUniqueName "contoso_crm";
``` 


```Powershell 
$status = Uninstall-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_crm" -PassThru;
``` 


```Powershell 
# Idempotent cleanup of a temporary container solution (alias Remove-XrmSolution)
Remove-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "contoso_temp" -OnlyIfEmpty -IfExists;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Uninstall-XrmSolution.md



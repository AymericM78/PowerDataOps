# Command : `Remove-XrmWorkflow` 

## Description

**Delete a process (classic workflow, cloud flow, action, business rule, business process flow).** : Delete a workflow row, optionally turning it off first.
Raises an error when the process is managed (remove it by uninstalling its solution) or does not exist.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
WorkflowReference|EntityReference|2|true||Reference of the process (workflow) to delete.
Deactivate|SwitchParameter|named|false|False|Turn the process off before deleting it (the platform refuses to delete an activated classic workflow).
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmWorkflow [[-XrmClient] <ServiceClient>] [-WorkflowReference] <EntityReference> [-Deactivate] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$flow = Get-XrmWorkflows -XrmClient $xrmClient -Category 5 -Name "Old sync" | Select-Object -First 1;
Remove-XrmWorkflow -XrmClient $xrmClient -WorkflowReference $flow.Reference -Deactivate;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmWorkflow.md



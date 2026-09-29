# Command : `Enable-XrmWorkflow` 

## Description

**Enable a workflow.** : Activate given workflow.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
WorkflowReference|EntityReference|2|true||Entity reference of the workflow to enable.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Enable-XrmWorkflow [[-XrmClient] <ServiceClient>] [-WorkflowReference] <EntityReference> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$wfRef = New-XrmEntityReference -LogicalName "workflow" -Id $workflowId;
Enable-XrmWorkflow -WorkflowReference $wfRef;
``` 



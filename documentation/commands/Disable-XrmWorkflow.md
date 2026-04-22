# Command : `Disable-XrmWorkflow` 

## Description

**Disable a workflow.** : Deactivate given workflow.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
WorkflowReference|EntityReference|2|true||Entity reference of the workflow to disable.

## Outputs
System.Void.

## Usage

```Powershell 
Disable-XrmWorkflow [[-XrmClient] <ServiceClient>] [-WorkflowReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$wfRef = New-XrmEntityReference -LogicalName "workflow" -Id $workflowId;
Disable-XrmWorkflow -WorkflowReference $wfRef;
``` 



# Command : `Invoke-XrmWorkflow` 

## Description

**Execute a workflow on a specific record.** : Trigger an on-demand workflow (classic workflow) on a target record using the ExecuteWorkflow SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
WorkflowReference|EntityReference|2|true||EntityReference of the workflow to execute.
RecordReference|EntityReference|3|true||EntityReference of the target record to run the workflow against.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The ExecuteWorkflow response containing AsyncOperationId.

## Usage

```Powershell 
Invoke-XrmWorkflow [[-XrmClient] <ServiceClient>] [-WorkflowReference] <EntityReference> [-RecordReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$wfRef = New-XrmEntityReference -LogicalName "workflow" -Id $workflowId;
$recordRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
$response = Invoke-XrmWorkflow -WorkflowReference $wfRef -RecordReference $recordRef;
$asyncJobId = $response.Results["Id"];
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/executeworkflow



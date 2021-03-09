# Command : `Disable-XrmWorkflow` 

## Description

**Disable a workflow.** : Deactivate given workflow.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
WorkflowId|Guid|2|true||Workflow unique identifier.


## Usage

```Powershell 
Disable-XrmWorkflow [[-XrmClient] <CrmServiceClient>] [-WorkflowId] <Guid> [<CommonParameters>]
``` 



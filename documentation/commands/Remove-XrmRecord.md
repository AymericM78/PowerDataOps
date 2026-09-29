# Command : `Remove-XrmRecord` 

## Description

**Remove record from Microsoft Dataverse.** : Delete row (entity record) from Microsoft Dataverse table by logicalname + id or by Entity object.
With AsRequest, the DeleteRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Record|Entity|2|false||Record (row) to delete.
LogicalName|String|3|false||Table / Entity logical name..
Id|Guid|4|false||Row (entity record) unique identifier
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)
BypassBusinessLogicExecution|String[]|5|false||Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.
BypassBusinessLogicExecutionStepIds|Guid[]|6|false||Ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows registered on the operation.
Tag|String|7|false||Value shared with the plug-ins (SharedVariables["tag"]).
AsRequest|SwitchParameter|named|false|False|Return the DeleteRequest without sending it.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void. With AsRequest: Microsoft.Xrm.Sdk.Messages.DeleteRequest.

## Usage

```Powershell 
Remove-XrmRecord [[-XrmClient] <ServiceClient>] [[-Record] <Entity>] [[-LogicalName] <String>] [[-Id] <Guid>] [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [[-Tag] <String>] [-AsRequest] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmRecord -XrmClient $xrmClient -LogicalName "account" -Id $accountId;
``` 


```Powershell 
$requests = $ids | ForEach-Object { Remove-XrmRecord -LogicalName "account" -Id $_ -BypassBusinessLogicExecution CustomSync -AsRequest };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmRecord.md



# Command : `Set-XrmRecordState` 

## Description

**Set the state and status of a record.** : Update the statecode and statuscode of a Dataverse record using Update-XrmRecord.
With AsRequest, the UpdateRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RecordReference|EntityReference|2|true||Entity reference of the target record.
StateCode|Int32|3|true|0|State code value to set (e.g., 0 = Active, 1 = Inactive).
StatusCode|Int32|4|true|0|Status code value to set. Must be valid for the given state code.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)
BypassBusinessLogicExecution|String[]|5|false||Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.
BypassBusinessLogicExecutionStepIds|Guid[]|6|false||Ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows registered on the operation.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Do not run the duplicate detection rules.
Tag|String|7|false||Value shared with the plug-ins (SharedVariables["tag"]).
AsRequest|SwitchParameter|named|false|False|Return the UpdateRequest without sending it.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. The record reference. With AsRequest: Microsoft.Xrm.Sdk.Messages.UpdateRequest.

## Usage

```Powershell 
Set-XrmRecordState [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [-StateCode] <Int32> [-StatusCode] <Int32> [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [-AsRequest] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
Set-XrmRecordState -XrmClient $xrmClient -RecordReference $accountRef -StateCode 1 -StatusCode 2;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmRecordState.md



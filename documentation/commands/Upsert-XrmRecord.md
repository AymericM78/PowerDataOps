# Command : `Upsert-XrmRecord` 

## Description

**Upsert entity record in Dataverse.** : Upsert row (entity record) from Microsoft Dataverse table.
With AsRequest, the UpsertRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Record|Entity|2|true||Record (row) to Upsert.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)
BypassBusinessLogicExecution|String[]|3|false||Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.
BypassBusinessLogicExecutionStepIds|Guid[]|4|false||Ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows registered on the operation.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Do not run the duplicate detection rules.
Tag|String|5|false||Value shared with the plug-ins (SharedVariables["tag"]).
AsRequest|SwitchParameter|named|false|False|Return the UpsertRequest without sending it.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The Upsert response. With AsRequest: Microsoft.Xrm.Sdk.Messages.UpsertRequest.

## Usage

```Powershell 
Upsert-XrmRecord [[-XrmClient] <ServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [-AsRequest] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$record = New-XrmEntity -LogicalName "account" -Attributes @{ "name" = "Contoso" };
Upsert-XrmRecord -Record $record;
``` 


```Powershell 
$request = Upsert-XrmRecord -Record $record -BypassBusinessLogicExecution CustomSync -Tag "sync" -AsRequest;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmRecord.md



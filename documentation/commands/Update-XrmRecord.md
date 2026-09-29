# Command : `Update-XrmRecord` 

## Description

**Update entity record in Microsoft Dataverse.** : Update row (entity record) from Microsoft Dataverse table.
With AsRequest, the UpdateRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Record|Entity|2|true||Record (row) to update.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)
BypassBusinessLogicExecution|String[]|3|false||Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.
BypassBusinessLogicExecutionStepIds|Guid[]|4|false||Ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows registered on the operation.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Do not run the duplicate detection rules.
Tag|String|5|false||Value shared with the plug-ins (SharedVariables["tag"]).
AsRequest|SwitchParameter|named|false|False|Return the UpdateRequest without sending it.

## Outputs
System.Void. With AsRequest: Microsoft.Xrm.Sdk.Messages.UpdateRequest.

## Usage

```Powershell 
Update-XrmRecord [[-XrmClient] <ServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [-AsRequest] [<CommonParameters>]
``` 

## Examples

```Powershell 
$account = New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ "name" = "Contoso Ltd" };
Update-XrmRecord -XrmClient $xrmClient -Record $account -BypassBusinessLogicExecution CustomSync -SuppressCallbackRegistrationExpanderJob;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecord.md



# Command : `Update-XrmRecords` 

## Description

**Update many records, in batches, optionally in parallel.** : Build one UpdateRequest per record (Update-XrmRecord -AsRequest, with the request options) and send them in ExecuteMultiple batches:
one after the other (Invoke-XrmBulkRequests), or on several threads with Parallel (Invoke-XrmParallelRequests).
Returns one object per fault: Index (position in Records), Count, RequestName, Message. Nothing is returned when every update succeeded.
Without ContinueOnError, the first fault stops the processing and raises an error naming it.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Records|Entity[]|2|true||Records to update: entities with an Id and only the columns to change.
Parallel|SwitchParameter|named|false|False|Send the batches on several threads (PowerShell 7).
BatchSize|Int32|3|false|0|Number of requests per ExecuteMultiple call. (Default: 500 sequential, 10 parallel)
ThreadCount|Int32|4|false|0|Number of threads with Parallel. 0 uses the RecommendedDegreesOfParallelism of the organization. (Default: 0)
ContinueOnError|SwitchParameter|named|false|False|Process every record and return the faults, instead of stopping at the first one.
Label|String|5|false||Label of the progress lines with Parallel. (Default: "Update <table>")
Quiet|SwitchParameter|named|false|False|Do not write progress lines.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins.
BypassBusinessLogicExecution|String[]|6|false||Custom business logic to bypass: CustomSync, CustomAsync, or both.
BypassBusinessLogicExecutionStepIds|Guid[]|7|false||Ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Do not run the duplicate detection rules.
Tag|String|8|false||Value shared with the plug-ins.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
PSCustomObject. One object per fault: Index, Count, RequestName, Message.

## Usage

```Powershell 
Update-XrmRecords [[-XrmClient] <ServiceClient>] [-Records] <Entity[]> [-Parallel] [[-BatchSize] <Int32>] [[-ThreadCount] <Int32>] [-ContinueOnError] [[-Label] <String>] [-Quiet] [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$updates = $accounts | ForEach-Object { New-XrmEntity -LogicalName "account" -Id $_.Id -Attributes @{ description = "Migrated" } };
$faults = Update-XrmRecords -XrmClient $xrmClient -Records $updates -Parallel -ContinueOnError -BypassBusinessLogicExecution CustomSync, CustomAsync;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Update-XrmRecords.md



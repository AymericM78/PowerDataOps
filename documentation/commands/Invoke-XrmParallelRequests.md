# Command : `Invoke-XrmParallelRequests` 

## Description

**Execute requests in parallel, in small ExecuteMultiple batches.** : Send a large set of requests to Microsoft Dataverse on several threads: each thread uses its own clone of the connection (affinity cookie disabled, so the load spreads over the web servers) and takes its batches from a shared queue.
The ServiceClient retries the service protection errors (429) by itself, honoring the Retry-After delay.
Returns one object per fault: Index (0-based, global to Requests), Count (1, or the batch size when a whole batch was refused), RequestName, Message. Nothing is returned when every request succeeded.
Without ContinueOnError, the threads stop taking new batches at the first fault and an error naming it is raised.
Requires PowerShell 7 for parallelism; on Windows PowerShell 5.1 the batches are sent one after the other.
Use Invoke-XrmBulkRequests for a sequential run that returns the responses.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Requests|OrganizationRequest[]|2|true||Requests to execute (e.g. built with Add-, Update-, Upsert- or Remove-XrmRecord -AsRequest).
BatchSize|Int32|3|false|10|Number of requests per ExecuteMultiple call, from 1 to 1000. Small batches spread better over threads. (Default: 10)
ThreadCount|Int32|4|false|0|Number of threads. 0 uses the RecommendedDegreesOfParallelism of the organization, capped at 52. (Default: 0)
ContinueOnError|SwitchParameter|named|false|False|Process every request and return the faults, instead of stopping at the first one.
Label|String|5|false|Requests|Label of the progress lines. (Default: "Requests")
Quiet|SwitchParameter|named|false|False|Do not write progress lines.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Added to every request: legacy bypass of synchronous custom plug-ins.
BypassBusinessLogicExecution|String[]|6|false||Added to every request: custom business logic to bypass (CustomSync, CustomAsync).
BypassBusinessLogicExecutionStepIds|Guid[]|7|false||Added to every request: ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Added to every request: do not trigger Power Automate flows.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Added to every request: do not run duplicate detection.
Tag|String|8|false||Added to every request: value shared with the plug-ins.

## Outputs
PSCustomObject. One object per fault: Index, Count, RequestName, Message.

## Usage

```Powershell 
Invoke-XrmParallelRequests [[-XrmClient] <ServiceClient>] [-Requests] <OrganizationRequest[]> [[-BatchSize] <Int32>] [[-ThreadCount] <Int32>] [-ContinueOnError] [[-Label] <String>] [-Quiet] [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$requests = $rows | ForEach-Object { Update-XrmRecord -Record $_ -AsRequest };
$faults = Invoke-XrmParallelRequests -XrmClient $xrmClient -Requests $requests -ContinueOnError -BypassBusinessLogicExecution CustomSync, CustomAsync -Label "Backfill";
$faults | Format-Table Index, Message;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/send-parallel-requests



# Command : `Invoke-XrmBulkRequests` 

## Description

**Split and Execute Multiple Organization Requests.** : Send requests to Microsoft Dataverse for bulk execution, in ExecuteMultiple batches of BatchSize requests.
Without ContinueOnError, the first fault stops the processing and raises an error that names the faulted request (global index and request name); the requests before it were executed.
With ContinueOnError, every request is processed. The faults are reported at the end in one non-terminating error whose TargetObject holds one object per fault: Index (0-based, global to the Requests array), Count (1, or the batch size when a whole batch was refused), RequestName and Message. Capture them with -ErrorVariable.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Requests|OrganizationRequest[]|2|true||Array of organization requests to execute.
BatchSize|Int32|3|false|500|Number of requests sent in each ExecuteMultiple call, from 1 to 1000. (Default: 500)
ContinueOnError|Boolean|4|false|False|Indicates whether to continue with the next requests when a request fails. (Default: false = stop at the first fault)
ReturnResponses|Boolean|5|false|False|Indicates if a response is returned for each request. (Default: false = No response)
Quiet|SwitchParameter|named|false|False|Do not log a line for each batch.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Added to every request: legacy bypass of synchronous custom plug-ins.
BypassBusinessLogicExecution|String[]|6|false||Added to every request: custom business logic to bypass (CustomSync, CustomAsync).
BypassBusinessLogicExecutionStepIds|Guid[]|7|false||Added to every request: ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Added to every request: do not trigger Power Automate flows.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Added to every request: do not run duplicate detection.
Tag|String|8|false||Added to every request: value shared with the plug-ins.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. With ReturnResponses, one response per request, in request order ($null for a faulted request).

## Usage

```Powershell 
Invoke-XrmBulkRequests [[-XrmClient] <ServiceClient>] [-Requests] <OrganizationRequest[]> [[-BatchSize] <Int32>] [[-ContinueOnError] <Boolean>] [[-ReturnResponses] <Boolean>] [-Quiet] [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$responses = Invoke-XrmBulkRequests -Requests $requests -ReturnResponses $true;
``` 


```Powershell 
Invoke-XrmBulkRequests -Requests $requests -ContinueOnError $true -ErrorVariable bulkErrors -ErrorAction SilentlyContinue;
$faults = $bulkErrors | ForEach-Object { $_.TargetObject };
$faults | Format-Table Index, RequestName, Message;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmBulkRequests.md



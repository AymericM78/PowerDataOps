# Command : `Set-XrmRequestOptions` 

## Description

**Set the optional parameters of a Dataverse request.** : Add the optional parameters that the platform reads on data operations (Create, Update, Upsert, Delete, ExecuteMultiple items...):
bypass of custom business logic, bypass of given plug-in steps, no Power Automate trigger, no duplicate detection, tag shared with plug-ins.
Only the options given are set; a value already present on the request is replaced. Returns the request, for pipeline chaining.
Bypassing business logic requires the prvBypassCustomBusinessLogic privilege (or prvBypassCustomPlugins for BypassCustomPluginExecution).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Request|OrganizationRequest|1|true||Organization request to complete.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins (BypassCustomPluginExecution parameter). Prefer BypassBusinessLogicExecution.
BypassBusinessLogicExecution|String[]|2|false||Custom business logic to bypass: CustomSync (synchronous plug-ins and real-time workflows), CustomAsync (asynchronous plug-ins and workflows), or both.
BypassBusinessLogicExecutionStepIds|Guid[]|3|false||Ids of the plug-in steps (sdkmessageprocessingstep) to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows registered on the operation.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Do not run the duplicate detection rules.
Tag|String|4|false||Value shared with the plug-ins through the execution context (SharedVariables["tag"]).

## Outputs
Microsoft.Xrm.Sdk.OrganizationRequest. The request, for pipeline chaining.

## Usage

```Powershell 
Set-XrmRequestOptions [-Request] <OrganizationRequest> [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$request = New-XrmRequest -Name "Create" | Add-XrmRequestParameter -Name "Target" -Value $record;
$request = $request | Set-XrmRequestOptions -BypassBusinessLogicExecution CustomSync, CustomAsync -SuppressCallbackRegistrationExpanderJob -Tag "migration";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/optional-parameters



# Command : `Add-XrmRecord` 

## Description

**Create entity record in Microsoft Dataverse.** : Add a new row in Microsoft Dataverse table and return created ID (Uniqueidentifier).
With AsRequest, the CreateRequest is returned without being sent (for Invoke-XrmBulkRequests or Invoke-XrmParallelRequests).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Record|Entity|2|true||Record information to add. (Entity)
BypassCustomPluginExecution|SwitchParameter|named|false|False|Legacy bypass of synchronous custom plug-ins. Prefer BypassBusinessLogicExecution. (Default: False)
BypassBusinessLogicExecution|String[]|3|false||Custom business logic to bypass: CustomSync, CustomAsync, or both. Requires the prvBypassCustomBusinessLogic privilege.
BypassBusinessLogicExecutionStepIds|Guid[]|4|false||Ids of the plug-in steps to bypass.
SuppressCallbackRegistrationExpanderJob|SwitchParameter|named|false|False|Do not trigger the Power Automate flows registered on the operation.
SuppressDuplicateDetection|SwitchParameter|named|false|False|Do not run the duplicate detection rules.
Tag|String|5|false||Value shared with the plug-ins (SharedVariables["tag"]).
AsRequest|SwitchParameter|named|false|False|Return the CreateRequest without sending it.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Guid. Newly created record identified. With AsRequest: Microsoft.Xrm.Sdk.Messages.CreateRequest.

## Usage

```Powershell 
Add-XrmRecord [[-XrmClient] <ServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] [[-BypassBusinessLogicExecution] <String[]>] [[-BypassBusinessLogicExecutionStepIds] <Guid[]>] [-SuppressCallbackRegistrationExpanderJob] [-SuppressDuplicateDetection] [[-Tag] <String>] [-AsRequest] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$account = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = "Contoso";
    "revenue" = New-XrmMoney -Value 123456.78;
    "industrycode" = New-XrmOptionSetValue -Value 37;
}
$account.Id = Add-XrmRecord -XrmClient $xrmClient -Record $account;
``` 


```Powershell 
$requests = $accounts | ForEach-Object { Add-XrmRecord -Record $_ -BypassBusinessLogicExecution CustomSync, CustomAsync -AsRequest };
Invoke-XrmBulkRequests -XrmClient $xrmClient -Requests $requests;
``` 

## More informations

System.Object[]



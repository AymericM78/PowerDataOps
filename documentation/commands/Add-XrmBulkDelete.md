# Command : `Add-XrmBulkDelete` 

## Description

**Create a bulk delete job.** : Submit a BulkDeleteRequest to asynchronously delete records matching a given query expression.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Query|QueryExpression|2|true||QueryExpression defining the records to delete.
JobName|String|3|false|Bulk Delete|Name of the bulk delete job. (Default: "Bulk Delete")
SendEmailNotification|Boolean|4|false|False|Whether to send email notification when the job completes. (Default: false)
ToRecipients|Guid[]|5|false|@()|Array of system user entity references to receive email notification. (Default: empty)
CCRecipients|Guid[]|6|false|@()|Array of system user entity references to receive email notification in CC. (Default: empty)
RecurrencePattern|String|7|false||Recurrence pattern for the bulk delete job. Empty string for one-time execution. (Default: "")
StartDateTime|DateTime|8|false|[datetime]::UtcNow|UTC date/time at which the bulk delete job should start. (Default: now)
SourceImportId|Guid|9|false|[Guid]::Empty|Optional source import unique identifier to scope the deletion.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. BulkDelete response containing JobId.

## Usage

```Powershell 
Add-XrmBulkDelete [[-XrmClient] <ServiceClient>] [-Query] <QueryExpression> [[-JobName] <String>] [[-SendEmailNotification] <Boolean>] [[-ToRecipients] <Guid[]>] [[-CCRecipients] <Guid[]>] 
[[-RecurrencePattern] <String>] [[-StartDateTime] <DateTime>] [[-SourceImportId] <Guid>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$query = New-XrmQueryExpression -LogicalName "account" -Columns "accountid";
$query | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values @(1);
$response = Add-XrmBulkDelete -XrmClient $xrmClient -Query $query -JobName "Clean inactive accounts";
$jobId = $response.Results["JobId"];
``` 



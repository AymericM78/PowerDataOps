# Command : `Get-XrmMultipleRecords` 

## Description

**Retrieve multiple records with QueryExpression.** : Get rows from Microsoft Dataverse table with specified query (QueryBase).
This command use pagination to pull all records.
By default the rows are converted to custom objects and written to the pipeline one by one: no row gives nothing and one row gives a single object. Use AsArray to always get an array, and AsEntity to get the SDK Entity objects.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Query|QueryBase|2|true||Query that select and filter data from Microsoft Dataverse table. (QueryBase)
PageSize|Int32|3|false|1000|Specify row count per page to pull. (Default: 1000)
ShowProgress|SwitchParameter|named|false|False|Display a progress bar while pages are retrieved.
AsArray|SwitchParameter|named|false|False|Return the rows as one array, never unrolled: an empty array when nothing matches, an array of one row for a single match.
AsEntity|SwitchParameter|named|false|False|Return the SDK Entity objects instead of converted custom objects (no formatted value columns).

## Outputs
Custom Objects array. Rows (= Entity records) are converted to custom object to simplify data operations. With AsEntity: Microsoft.Xrm.Sdk.Entity.

## Usage

```Powershell 
Get-XrmMultipleRecords [[-XrmClient] <ServiceClient>] [-Query] <QueryBase> [[-PageSize] <Int32>] [-ShowProgress] [-AsArray] [-AsEntity] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$queryAccounts = New-XrmQueryExpression -LogicalName "account" -Columns "*" `
                | Add-XrmQueryCondition -Field "name" -Condition Like -Values "D%" `
                | Add-XrmQueryCondition -Field "createdon" -Condition LastXMonths -Values 20;
$accounts = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts;
``` 


```Powershell 
$accounts = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts -AsArray;
Write-Host "$($accounts.Count) account(s)";
``` 


```Powershell 
$entities = Get-XrmMultipleRecords -XrmClient $xrmClient -Query $queryAccounts -AsEntity -AsArray;
``` 

## More informations

System.Object[]



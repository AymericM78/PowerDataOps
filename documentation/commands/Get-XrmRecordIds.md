# Command : `Get-XrmRecordIds` 

## Description

**Get the ids of the rows of a table.** : Return the ids of all the rows of LogicalName, or of the rows matching Query, as a HashSet[Guid] (fast membership test with Contains).
Only the ids are read, page by page (5,000 rows per page); the columns of the query are restored after the call.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|named|true||Table / Entity logical name. Optional when Query is given.
Query|QueryExpression|named|true||QueryExpression selecting the rows. (Default: all rows of LogicalName)

## Outputs
System.Collections.Generic.HashSet[Guid]. Ids of the rows.

## Usage

```Powershell 
Get-XrmRecordIds [-XrmClient <ServiceClient>] -LogicalName <String> [<CommonParameters>]

Get-XrmRecordIds [-XrmClient <ServiceClient>] [-LogicalName <String>] -Query <QueryExpression> [<CommonParameters>]
``` 

## Examples

```Powershell 
$existingIds = Get-XrmRecordIds -XrmClient $xrmClient -LogicalName "account";
$toCreate = $sourceRows | Where-Object { -not $existingIds.Contains($_.Id) };
``` 


```Powershell 
$query = New-XrmQueryExpression -LogicalName "contact" | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values 0;
$activeContactIds = Get-XrmRecordIds -XrmClient $xrmClient -Query $query;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordIds.md



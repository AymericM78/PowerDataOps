# Command : `Get-XrmRecordCount` 

## Description

**Count the rows matching a query.** : Return the exact number of rows matching a QueryExpression or a FetchXml query, filters and links included.
The count is first asked as an aggregate (countcolumn, distinct on the primary key, so a one-to-many link does not count a row twice). When the platform refuses the aggregate (more than 50,000 rows: AggregateQueryRecordLimit), the rows are paged, reading only their ids.
Columns and orders of the query are ignored; a top / TopCount caps the result. The caller's query is not modified.
For approximate counts of whole tables, see Get-XrmTotalRecordCount.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Query|QueryExpression|named|true||QueryExpression selecting the rows to count.
FetchXml|String|named|true||FetchXml query selecting the rows to count.
NoAggregate|SwitchParameter|named|false|False|Skip the aggregate and count by paging (for tables that refuse aggregates).

## Outputs
System.Int64. Number of matching rows.

## Usage

```Powershell 
Get-XrmRecordCount [-XrmClient <ServiceClient>] -Query <QueryExpression> [-NoAggregate] [<CommonParameters>]

Get-XrmRecordCount [-XrmClient <ServiceClient>] -FetchXml <String> [-NoAggregate] [<CommonParameters>]
``` 

## Examples

```Powershell 
$query = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "statecode" -Condition Equal -Values 0;
$activeAccounts = Get-XrmRecordCount -XrmClient $xrmClient -Query $query;
``` 


```Powershell 
<entity name="contact"><filter><condition attribute="parentcustomerid" operator="not-null" /></filter></entity></fetch>';
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRecordCount.md



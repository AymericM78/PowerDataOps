# Command : `Get-XrmTotalRecordCount` 

## Description

**Returns total number of rows in given entity / table.** : Returns data on the total number of records for specific entities. (RetrieveTotalRecordCount)
These counts come from a periodic snapshot: use Get-XrmRecordCount for an exact, filtered count.
One table the platform refuses makes the whole request fail; with SkipRefused, the tables are then asked one by one and the refused ones are skipped with a warning.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalNames|String[]|2|true||The logical names of the entities to include in the query.
SkipRefused|SwitchParameter|named|false|False|Skip (with a warning) the tables the platform refuses to count, instead of failing the whole call.
AsHashtable|SwitchParameter|named|false|False|Return a hashtable: logical name = count.

## Outputs
Microsoft.Xrm.Sdk.EntityRecordCountCollection (enumerated as logical name / count pairs). With AsHashtable: Hashtable.

## Usage

```Powershell 
Get-XrmTotalRecordCount [[-XrmClient] <ServiceClient>] [-LogicalNames] <String[]> [-SkipRefused] [-AsHashtable] [<CommonParameters>]
``` 

## Examples

```Powershell 
$counts = Get-XrmTotalRecordCount -XrmClient $xrmClient -LogicalNames "account", "contact" -AsHashtable;
Write-Host "$($counts.account) accounts";
``` 


```Powershell 
$counts = Get-XrmTotalRecordCount -XrmClient $xrmClient -LogicalNames $allTables -SkipRefused -AsHashtable;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmTotalRecordCount.md



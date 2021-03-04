# Command : `Get-XrmTotalRecordCount` 

## Description

**Returns total number of rows in given entity / table.** : Returns data on the total number of records for specific entities. (RetrieveTotalRecordCount)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
LogicalNames|String[]|2|true||The logical names of the entities to include in the query.

## Outputs

## Usage

```Powershell 
Get-XrmTotalRecordCount [[-XrmClient] <CrmServiceClient>] [-LogicalNames] <String[]> [<CommonParameters>]
``` 



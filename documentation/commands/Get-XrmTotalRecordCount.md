# Command : `Get-XrmTotalRecordCount` 

## Description

**Returns total number of rows in given entity / table.** : Returns data on the total number of records for specific entities. (RetrieveTotalRecordCount)

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalNames|String[]|2|true||The logical names of the entities to include in the query.


## Usage

```Powershell 
Get-XrmTotalRecordCount [[-XrmClient] <ServiceClient>] [-LogicalNames] <String[]> [<CommonParameters>]
``` 



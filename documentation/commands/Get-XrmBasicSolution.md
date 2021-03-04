# Command : `Get-XrmBasicSolution` 

## Description

**Retrieve basic solution record.** : Get basic solution with specified column.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)

## Outputs

## Usage

```Powershell 
Get-XrmBasicSolution [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



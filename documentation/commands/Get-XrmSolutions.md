# Command : `Get-XrmSolutions` 

## Description

**Retrieve solutions records.** : Get all solutions from instance with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)

## Outputs

## Usage

```Powershell 
Get-XrmSolutions [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



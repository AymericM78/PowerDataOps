# Command : `Clear-XrmSolutions` 

## Description

**Select solutions to uninstall.** : Select solutions (managed or unmanaged) and delete them.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)
TimeOutInMinutes|Int32|3|false|45|Specify timeout duration in minute for each solution deletion. (Default : 45 min)


## Usage

```Powershell 
Clear-XrmSolutions [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [[-TimeOutInMinutes] <Int32>] [<CommonParameters>]
``` 



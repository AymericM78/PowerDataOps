# Command : `Get-XrmSolution` 

## Description

**Retrieve solution record.** : Get solution by its unique name with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to retrieve.
Columns|String[]|3|false|@("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)


## Usage

```Powershell 
Get-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [[-Columns] <String[]>] 
[<CommonParameters>]
``` 



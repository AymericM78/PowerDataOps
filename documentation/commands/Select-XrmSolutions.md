# Command : `Select-XrmSolutions` 

## Description

**Display solutions selector.** : Open gridview view all solutions and select one or many.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OutputMode|OutputModeOption|2|false|Single|Specify if selector should allow single or multiple items selection. (Default : Single)
Columns|String[]|3|false|@("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby")|Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)


## Usage

```Powershell 
Select-XrmSolutions [[-XrmClient] <ServiceClient>] [[-OutputMode] {None | Single | Multiple}] [[-Columns] <String[]>] 
[<CommonParameters>]
``` 



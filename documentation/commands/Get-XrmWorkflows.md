# Command : `Get-XrmWorkflows` 

## Description

**Retrieve workflows.** : Get workflows with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@( "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")|Specify expected columns to retrieve. (Default : "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")


## Usage

```Powershell 
Get-XrmWorkflows [[-XrmClient] <ServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



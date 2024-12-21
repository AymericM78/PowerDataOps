# Command : `Get-XrmUser` 

## Description

**Retrieve user.** : Get system user according to given ID with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UserId|Guid|2|false||System user unique identifier.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)


## Usage

```Powershell 
Get-XrmUser [[-XrmClient] <ServiceClient>] [[-UserId] <Guid>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



# Command : `Get-XrmUserBusinessUnit` 

## Description

**Retrieve user business unit.** : Get user parent business unit.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
UserId|Guid|2|true||System user unique identifier.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)


## Usage

```Powershell 
Get-XrmUserBusinessUnit [[-XrmClient] <CrmServiceClient>] [-UserId] <Guid> [[-Columns] <String[]>] [<CommonParameters>]
``` 



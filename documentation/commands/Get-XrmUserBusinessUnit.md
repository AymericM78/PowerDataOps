# Command : `Get-XrmUserBusinessUnit` 

## Description

**Retrieve user business unit.** : Get user parent business unit.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UserId|Guid|2|true||System user unique identifier.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)


## Usage

```Powershell 
Get-XrmUserBusinessUnit [[-XrmClient] <ServiceClient>] [-UserId] <Guid> [[-Columns] <String[]>] [<CommonParameters>]
``` 



# Command : `Get-XrmUserRoles` 

## Description

**Retrieve user assigned security roles.** : Get security roles associated to given user.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
UserId|Guid|2|true||System user unique identifier.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs

## Usage

```Powershell 
Get-XrmUserRoles [[-XrmClient] <CrmServiceClient>] [-UserId] <Guid> [[-Columns] <String[]>] [<CommonParameters>]
``` 



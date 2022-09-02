# Command : `Get-XrmUsersRoles` 

## Description

**Retrieve assigned security roles for all users.** : Get all users with associated roles. This could help to determine unused roles or bad configurations.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@("fullname", "internalemailaddress")|Specify expected columns to retrieve. (Default : all columns)
UserQueryConditions|Object|3|false|@()|Query condition arrays used to filter user query.


## Usage

```Powershell 
Get-XrmUsersRoles [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [[-UserQueryConditions] <Object>] 
[<CommonParameters>]
``` 



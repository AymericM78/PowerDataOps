# Command : `Add-XrmUserRoles` 

## Description

**Add security roles to user.** : Assign on or multiple roles to given user.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|
UserId|Guid|2|true||System user unique identifier.
Roles|Guid[]|3|true|@()|Roles unique identifier array to add.


## Usage

```Powershell 
Add-XrmUserRoles [[-XrmClient] <CrmServiceClient>] [-UserId] <Guid> [-Roles] <Guid[]> [<CommonParameters>]
``` 



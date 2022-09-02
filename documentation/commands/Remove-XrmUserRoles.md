# Command : `Remove-XrmUserRoles` 

## Description

**Remove security roles to user.** : Unassign one or multiple roles to given user.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|
UserReference|EntityReference|2|true||
Roles|Guid[]|3|true|@()|Roles unique identifier array to add.


## Usage

```Powershell 
Remove-XrmUserRoles [[-XrmClient] <CrmServiceClient>] [-UserReference] <EntityReference> [-Roles] <Guid[]> 
[<CommonParameters>]
``` 



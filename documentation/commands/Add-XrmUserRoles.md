# Command : `Add-XrmUserRoles` 

## Description

**Add security roles to user.** : Assign on or multiple roles to given user.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|
UserReference|EntityReference|2|true||
Roles|Guid[]|3|true|@()|Roles unique identifier array to add.


## Usage

```Powershell 
Add-XrmUserRoles [[-XrmClient] <ServiceClient>] [-UserReference] <EntityReference> [-Roles] <Guid[]> [<CommonParameters>]
``` 



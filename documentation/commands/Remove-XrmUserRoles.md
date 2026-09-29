# Command : `Remove-XrmUserRoles` 

## Description

**Remove security roles to user.** : Unassign one or multiple roles to given user.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|
UserReference|EntityReference|2|true||
Roles|Guid[]|3|true|@()|Roles unique identifier array to add.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmUserRoles [[-XrmClient] <ServiceClient>] [-UserReference] <EntityReference> [-Roles] <Guid[]> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmUserRoles -UserId $userId -Roles @($roleId1, $roleId2);
``` 



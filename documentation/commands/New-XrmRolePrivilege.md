# Command : `New-XrmRolePrivilege` 

## Description

**Create a RolePrivilege object.** : Instantiate a RolePrivilege object used to define a privilege with its depth for security role operations.
The privilege is given by PrivilegeId, by PrivilegeName, or by EntityLogicalName + AccessRight (e.g. account + Write => prvWriteAccount).
With ClampDepth, a depth the privilege does not support is replaced by the closest supported one: the highest supported depth below the requested one, else the lowest above it (e.g. Global only for organization-owned tables).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
PrivilegeId|Guid|1|false||Unique identifier of the privilege.
PrivilegeName|String|2|false||Name of the privilege (e.g. "prvReadAccount"). Used to resolve the PrivilegeId automatically if PrivilegeId is not provided.
Depth|PrivilegeDepth|3|true||Depth of the privilege (Basic, Local, Deep, Global).
BusinessUnitId|Guid|4|false|[Guid]::Empty|Business unit unique identifier. Optional, defaults to Guid.Empty.
XrmClient|ServiceClient|5|false|$Global:XrmClient|Xrm connector initialized to target instance, used to resolve PrivilegeName. Use latest one by default. (Dataverse ServiceClient)
Declared last to keep the existing positional parameters.
EntityLogicalName|String|6|false||Table of the privilege, with AccessRight, instead of PrivilegeId or PrivilegeName.
AccessRight|String|7|false||Access right of the privilege, with EntityLogicalName: Read, Write, Create, Delete, Append, AppendTo, Assign, Share.
ClampDepth|SwitchParameter|named|false|False|Replace a depth the privilege does not support by the closest supported one, instead of keeping it as given.

## Outputs
Microsoft.Crm.Sdk.Messages.RolePrivilege. The constructed RolePrivilege object.

## Usage

```Powershell 
New-XrmRolePrivilege [[-PrivilegeId] <Guid>] [[-PrivilegeName] <String>] [-Depth] {Basic | Local | Deep | Global | RecordFilter} [[-BusinessUnitId] <Guid>] [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-AccessRight] <String>] [-ClampDepth] [<CommonParameters>]
``` 

## Examples

```Powershell 
$priv = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
``` 


```Powershell 
$priv = New-XrmRolePrivilege -PrivilegeId $privilegeId -Depth Local;
``` 


```Powershell 
# Local where the table supports it, Global for organization-owned tables
$privileges = "account", "businessunit" | ForEach-Object { New-XrmRolePrivilege -XrmClient $xrmClient -EntityLogicalName $_ -AccessRight Read -Depth Local -ClampDepth };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmRolePrivilege.md



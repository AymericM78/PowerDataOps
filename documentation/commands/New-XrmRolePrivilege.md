# Command : `New-XrmRolePrivilege` 

## Description

**Create a RolePrivilege object.** : Instantiate a RolePrivilege object used to define a privilege with its depth for security role operations.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
PrivilegeId|Guid|1|false||Unique identifier of the privilege.
PrivilegeName|String|2|false||Name of the privilege (e.g. "prvReadAccount"). Used to resolve the PrivilegeId automatically if PrivilegeId is not provided.
Depth|PrivilegeDepth|3|true||Depth of the privilege (Basic, Local, Deep, Global).
BusinessUnitId|Guid|4|false|[Guid]::Empty|Business unit unique identifier. Optional, defaults to Guid.Empty.

## Outputs
Microsoft.Crm.Sdk.Messages.RolePrivilege. The constructed RolePrivilege object.

## Usage

```Powershell 
New-XrmRolePrivilege [[-PrivilegeId] <Guid>] [[-PrivilegeName] <String>] [-Depth] {Basic | Local | Deep | Global | RecordFilter} [[-BusinessUnitId] 
<Guid>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$priv = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
``` 


```Powershell 
$priv = New-XrmRolePrivilege -PrivilegeId $privilegeId -Depth Local;
``` 

## More informations

https://learn.microsoft.com/en-us/dotnet/api/microsoft.crm.sdk.messages.roleprivilege



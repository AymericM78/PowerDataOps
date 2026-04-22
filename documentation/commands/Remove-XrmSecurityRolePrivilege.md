# Command : `Remove-XrmSecurityRolePrivilege` 

## Description

**Remove a privilege from a security role.** : Remove a single privilege from an existing security role using the RemovePrivilegeRole SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleReference|EntityReference|2|true||Entity reference of the security role.
PrivilegeId|Guid|3|true||Unique identifier of the privilege to remove.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The RemovePrivilegeRole response.

## Usage

```Powershell 
Remove-XrmSecurityRolePrivilege [[-XrmClient] <ServiceClient>] [-RoleReference] <EntityReference> [-PrivilegeId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
Remove-XrmSecurityRolePrivilege -RoleReference $roleRef -PrivilegeId $privilegeId;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/removeprivilegerole



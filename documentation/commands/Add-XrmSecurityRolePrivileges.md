# Command : `Add-XrmSecurityRolePrivileges` 

## Description

**Add privileges to a security role.** : Add one or more privileges to an existing security role using the AddPrivilegesRole SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleReference|EntityReference|2|true||Entity reference of the security role.
Privileges|RolePrivilege[]|3|true||Array of RolePrivilege objects to add to the role. Use New-XrmRolePrivilege to create them.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The AddPrivilegesRole response.

## Usage

```Powershell 
Add-XrmSecurityRolePrivileges [[-XrmClient] <ServiceClient>] [-RoleReference] <EntityReference> [-Privileges] <RolePrivilege[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
$priv1 = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
$priv2 = New-XrmRolePrivilege -PrivilegeName "prvWriteAccount" -Depth Local;
Add-XrmSecurityRolePrivileges -RoleReference $roleRef -Privileges @($priv1, $priv2);
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/addprivilegesrole



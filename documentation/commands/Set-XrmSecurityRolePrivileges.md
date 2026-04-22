# Command : `Set-XrmSecurityRolePrivileges` 

## Description

**Replace all privileges on a security role.** : Replace the entire privilege set of an existing security role using the ReplacePrivilegesRole SDK message.
This removes all current privileges and sets only the ones provided.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleReference|EntityReference|2|true||Entity reference of the security role.
Privileges|RolePrivilege[]|3|true||Array of RolePrivilege objects that will replace all existing privileges. Use New-XrmRolePrivilege to create them.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The ReplacePrivilegesRole response.

## Usage

```Powershell 
Set-XrmSecurityRolePrivileges [[-XrmClient] <ServiceClient>] [-RoleReference] <EntityReference> [-Privileges] <RolePrivilege[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
$priv1 = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
$priv2 = New-XrmRolePrivilege -PrivilegeName "prvWriteAccount" -Depth Local;
Set-XrmSecurityRolePrivileges -RoleReference $roleRef -Privileges @($priv1, $priv2);
``` 


```Powershell 
$sourcePrivileges = Get-XrmRolePrivileges -RoleId $sourceRoleId;
Set-XrmSecurityRolePrivileges -RoleReference $targetRoleRef -Privileges $sourcePrivileges;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/replaceprivilegesrole



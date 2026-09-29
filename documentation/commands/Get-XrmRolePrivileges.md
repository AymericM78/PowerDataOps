# Command : `Get-XrmRolePrivileges` 

## Description

**Retrieve security role privileges.** : Get role privileges from given role (RetrieveRolePrivilegesRole): one RolePrivilege per privilege, with its depth.
Each RolePrivilege also carries EntityLogicalName and AccessRight (see Get-XrmPrivileges), and its PrivilegeName is filled when the platform leaves it empty.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleId|Guid|2|true||Role unique identifier.

## Outputs
Microsoft.Crm.Sdk.Messages.RolePrivilege[]. Privileges of the role, with the EntityLogicalName and AccessRight note properties.

## Usage

```Powershell 
Get-XrmRolePrivileges [[-XrmClient] <ServiceClient>] [-RoleId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$privileges = Get-XrmRolePrivileges -XrmClient $xrmClient -RoleId $role.Id;
$privileges | Where-Object { $_.EntityLogicalName -eq "account" } | Select-Object PrivilegeName, AccessRight, Depth;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRolePrivileges.md



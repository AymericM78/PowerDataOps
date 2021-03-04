# Command : `Get-XrmRolePrivileges` 

## Description

**Retrieve security role privileges.** : Get role privileges from given role.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
RoleId|Guid|2|true||Role unique identifier.

## Outputs

## Usage

```Powershell 
Get-XrmRolePrivileges [[-XrmClient] <CrmServiceClient>] [-RoleId] <Guid> [<CommonParameters>]
``` 



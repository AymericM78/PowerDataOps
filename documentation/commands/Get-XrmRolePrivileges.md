# Command : `Get-XrmRolePrivileges` 

## Description

**Retrieve security role privileges.** : Get role privileges from given role.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleId|Guid|2|true||Role unique identifier.


## Usage

```Powershell 
Get-XrmRolePrivileges [[-XrmClient] <ServiceClient>] [-RoleId] <Guid> [<CommonParameters>]
``` 



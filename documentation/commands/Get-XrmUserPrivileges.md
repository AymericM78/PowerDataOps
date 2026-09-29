# Command : `Get-XrmUserPrivileges` 

## Description

**Retrieve the privileges of a user.** : Get the privileges a user holds through their security roles (RetrieveUserPrivileges): one RolePrivilege per privilege and depth.
Each RolePrivilege also carries EntityLogicalName and AccessRight (see Get-XrmPrivileges), and its PrivilegeName is filled when the platform leaves it empty.
To check a single privilege, Test-XrmUserPrivilege is cheaper.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
UserId|Guid|2|false||System user unique identifier. (Default: current user)

## Outputs
Microsoft.Crm.Sdk.Messages.RolePrivilege[]. Privileges of the user, with the EntityLogicalName and AccessRight note properties.

## Usage

```Powershell 
Get-XrmUserPrivileges [[-XrmClient] <ServiceClient>] [[-UserId] <Guid>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$privileges = Get-XrmUserPrivileges -XrmClient $xrmClient -UserId $user.Id;
$privileges | Where-Object { $_.EntityLogicalName -eq "account" } | Select-Object PrivilegeName, AccessRight, Depth;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserPrivileges.md



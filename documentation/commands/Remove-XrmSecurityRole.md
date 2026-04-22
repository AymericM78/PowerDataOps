# Command : `Remove-XrmSecurityRole` 

## Description

**Delete a security role.** : Delete a security role (role) record from Microsoft Dataverse.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleReference|EntityReference|2|true||Entity reference of the security role to delete.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmSecurityRole [[-XrmClient] <ServiceClient>] [-RoleReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
Remove-XrmSecurityRole -RoleReference $roleRef;
``` 



# Command : `Set-XrmSecurityRole` 

## Description

**Update a security role.** : Update an existing security role (role) record in Microsoft Dataverse.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RoleReference|EntityReference|2|true||Entity reference of the security role to update.
Name|String|3|false||New display name for the security role.
Description|String|4|false||New description for the security role.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated role record.

## Usage

```Powershell 
Set-XrmSecurityRole [[-XrmClient] <ServiceClient>] [-RoleReference] <EntityReference> [[-Name] <String>] [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
Set-XrmSecurityRole -RoleReference $roleRef -Name "Updated Role Name";
``` 



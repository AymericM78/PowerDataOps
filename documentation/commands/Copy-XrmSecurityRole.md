# Command : `Copy-XrmSecurityRole` 

## Description

**Copy a security role.** : Clone an existing security role by creating a new role and copying all privileges from the source role using the ReplacePrivilegesRole SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SourceRoleReference|EntityReference|2|true||Entity reference of the source security role to copy privileges from.
Name|String|3|true||Display name for the new security role.
BusinessUnitReference|EntityReference|4|false||Business unit entity reference for the new role. Defaults to root business unit if not provided.
Description|String|5|false||Description for the new security role.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the newly created role record.

## Usage

```Powershell 
Copy-XrmSecurityRole [[-XrmClient] <ServiceClient>] [-SourceRoleReference] <EntityReference> [-Name] <String> [[-BusinessUnitReference] 
<EntityReference>] [[-Description] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$sourceRef = New-XrmEntityReference -LogicalName "role" -Id $existingRoleId;
$newRoleRef = Copy-XrmSecurityRole -SourceRoleReference $sourceRef -Name "Copy of Sales Role";
``` 


```Powershell 
$buRef = New-XrmEntityReference -LogicalName "businessunit" -Id $buId;
$newRoleRef = Copy-XrmSecurityRole -SourceRoleReference $sourceRef -Name "Cloned Role" -BusinessUnitReference $buRef;
``` 



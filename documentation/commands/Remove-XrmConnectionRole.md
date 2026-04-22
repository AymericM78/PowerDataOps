# Command : `Remove-XrmConnectionRole` 

## Description

**Delete a connection role from Microsoft Dataverse.** : Remove a connectionrole record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ConnectionRoleReference|EntityReference|2|true||EntityReference of the connectionrole record to delete.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmConnectionRole [[-XrmClient] <ServiceClient>] [-ConnectionRoleReference] <EntityReference> [<CommonParameters>]
``` 

## Examples

```Powershell 
$roleRef = New-XrmEntityReference -LogicalName "connectionrole" -Id $roleId;
Remove-XrmConnectionRole -ConnectionRoleReference $roleRef;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/describe-relationship-entities-connection-roles



# Command : `Remove-XrmAppModuleRoles` 

## Description

**Remove security roles from a model-driven app.** : Revoke access to a model-driven app for one or more security roles by removing
the association via the appmoduleroles_association N:N relationship.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||Reference to the appmodule record.
RoleReferences|EntityReference[]|3|true||Array of EntityReference objects pointing to the security roles to remove.

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmAppModuleRoles [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [-RoleReferences] <EntityReference[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Get-XrmAppModules -Name "My App" | Select-Object -First 1 | ForEach-Object { $_.Reference };
$role = Get-XrmRoles -Name "Sales Manager" | Select-Object -First 1;
Remove-XrmAppModuleRoles -AppModuleReference $appRef -RoleReferences @($role.Reference);
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest



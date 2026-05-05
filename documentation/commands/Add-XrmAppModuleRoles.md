# Command : `Add-XrmAppModuleRoles` 

## Description

**Assign security roles to a model-driven app.** : Grant one or more security roles access to a model-driven app via the
appmoduleroles_association N:N relationship. Users must belong to one of the
assigned roles to see the app in the app picker.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||Reference to the appmodule record.
RoleReferences|EntityReference[]|3|true||Array of EntityReference objects pointing to the security roles to assign.

## Outputs
System.Void.

## Usage

```Powershell 
Add-XrmAppModuleRoles [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [-RoleReferences] <EntityReference[]> [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Get-XrmAppModules -Name "My App" | Select-Object -First 1 | ForEach-Object { $_.Reference };
$role = Get-XrmRoles -Name "Sales Manager" | Select-Object -First 1;
Add-XrmAppModuleRoles -AppModuleReference $appRef -RoleReferences @($role.Reference);
``` 


```Powershell 
$roleRefs = Get-XrmRoles | Where-Object { $_.name -like "Sales*" } | ForEach-Object { $_.Reference };
Add-XrmAppModuleRoles -AppModuleReference $appRef -RoleReferences $roleRefs;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest



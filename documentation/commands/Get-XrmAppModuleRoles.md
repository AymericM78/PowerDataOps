# Command : `Get-XrmAppModuleRoles` 

## Description

**Retrieve security roles assigned to a model-driven app.** : Get the list of security roles that have access to a given model-driven app,
via the appmoduleroles_association N:N relationship.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppModuleReference|EntityReference|2|true||Reference to the appmodule record.
Columns|String[]|3|false|@("roleid", "name", "businessunitid")|Specify expected columns to retrieve from the role entity. (Default : roleid, name, businessunitid)

## Outputs
PSCustomObject[]. Array of role records (XrmObject) assigned to the app.

## Usage

```Powershell 
Get-XrmAppModuleRoles [[-XrmClient] <ServiceClient>] [-AppModuleReference] <EntityReference> [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$appRef = Get-XrmAppModules -Name "My App" | Select-Object -First 1 | ForEach-Object { $_.Reference };
$roles = Get-XrmAppModuleRoles -AppModuleReference $appRef;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest



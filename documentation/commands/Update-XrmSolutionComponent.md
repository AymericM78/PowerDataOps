# Command : `Update-XrmSolutionComponent` 

## Description

**Update a solution component.** : Update a component in an unmanaged solution using the UpdateSolutionComponent SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Unique name of the solution where the component should exist.
ComponentId|Guid|3|true||Unique identifier of the component to update.
ComponentType|Int32|4|true|0|Component type number (see Get-XrmSolutionComponentName to get name from type number).
IncludedComponentSettingsValues|String[]|5|false||Array of settings to include in the component update.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateSolutionComponent response.

## Usage

```Powershell 
Update-XrmSolutionComponent [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-ComponentId] <Guid> [-ComponentType] <Int32> 
[[-IncludedComponentSettingsValues] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Update-XrmSolutionComponent -SolutionUniqueName "MySolution" -ComponentId $tableId -ComponentType 1 -IncludedComponentSettingsValues @("Setting1");
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/updatesolutioncomponent



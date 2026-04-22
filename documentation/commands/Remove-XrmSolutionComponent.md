# Command : `Remove-XrmSolutionComponent` 

## Description

**Remove a component from an unmanaged solution.** : Remove given component from specified unmanaged solution using the RemoveSolutionComponent SDK message.
This does not delete the component from the environment, it only removes it from the solution.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Unmanaged solution unique name from which to remove the component.
ComponentId|Guid|3|true||Component unique identifier.
ComponentType|Int32|4|true|0|Component type number (see Get-XrmSolutionComponentName to get name from type number).

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. SDK response.

## Usage

```Powershell 
Remove-XrmSolutionComponent [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-ComponentId] <Guid> [-ComponentType] <Int32> 
[<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmSolutionComponent -SolutionUniqueName "contoso_crm" -ComponentId $entityId -ComponentType 1;
``` 


```Powershell 
$components = Get-XrmSolutionComponents -SolutionUniqueName "contoso_crm" -ComponentTypes @(26);
$components | ForEach-Object {
    Remove-XrmSolutionComponent -SolutionUniqueName "contoso_crm" -ComponentId $_.objectid -ComponentType 26;
};
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/reference/entities/solutioncomponent



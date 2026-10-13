# Command : `Set-XrmColumnVisualization` 

## Description

**Set or remove the visualization of a column in grids.** : Show a column as a small chart in the grid cells (column visualization of the maker portal: heat map, radial dial...), or go back to plain text with Remove.
The setting is a controlconfiguration row linked to the column, as the maker portal writes it: name CustomRenderersConfiguration, unique name msdyn_<table>_<column>_customrenderers, metadatajson {"type":"<renderer id>"}. It is created, or updated when the column already has one.
With SolutionUniqueName, the row is added to the solution under the component type of controlconfiguration in this organization (read by Get-XrmSolutionComponentType: the code differs between organizations).
The organization must have the controlconfiguration table (column visualization preview), else the command fails.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|named|true||Table / Entity logical name.
LogicalName|String|named|true||Column / Attribute logical name. Alias: AttributeLogicalName.
RendererId|Guid|named|true||Renderer id, as the maker portal stores it in controlconfiguration.metadatajson (read it once from a column set in the portal).
Remove|SwitchParameter|named|true|False|Remove the visualization (plain text). Nothing happens when the column has none.
SolutionUniqueName|String|named|false||Unmanaged solution to add the configuration to.
Cache|Hashtable|named|false||Hashtable owned by the caller and reused across calls: the component type of controlconfiguration is read once (see Get-XrmSolutionComponentType).
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. The controlconfiguration row. Nothing with Remove.

## Usage

```Powershell 
Set-XrmColumnVisualization [-XrmClient <ServiceClient>] -EntityLogicalName <String> -LogicalName <String> -RendererId <Guid> [-SolutionUniqueName <String>] [-Cache <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]

Set-XrmColumnVisualization [-XrmClient <ServiceClient>] -EntityLogicalName <String> -LogicalName <String> -Remove [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$cache = @{};
Set-XrmColumnVisualization -XrmClient $xrmClient -EntityLogicalName "new_project" -LogicalName "new_progress" -RendererId $heatMapRendererId -SolutionUniqueName "ContosoCore" -Cache $cache;
``` 


```Powershell 
Set-XrmColumnVisualization -XrmClient $xrmClient -EntityLogicalName "new_project" -LogicalName "new_progress" -Remove;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmColumnVisualization.md



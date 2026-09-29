# Command : `Remove-XrmChart` 

## Description

**Delete a chart from Microsoft Dataverse.** : Delete a savedqueryvisualization record (system chart).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ChartReference|EntityReference|2|true||EntityReference of the savedqueryvisualization to delete.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmChart [[-XrmClient] <ServiceClient>] [-ChartReference] <EntityReference> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmChart -ChartReference $chartRef;
``` 



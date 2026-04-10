# Command : `Set-XrmChart` 

## Description

**Update a chart in Microsoft Dataverse.** : Update an existing savedqueryvisualization record (system chart).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ChartReference|EntityReference|2|true||EntityReference of the savedqueryvisualization to update.
Name|String|3|false||Updated chart display name.
DataDescription|String|4|false||Updated data description XML.
PresentationDescription|String|5|false||Updated presentation description XML.
Description|String|6|false||Updated description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated savedqueryvisualization record.

## Usage

```Powershell 
Set-XrmChart [[-XrmClient] <ServiceClient>] [-ChartReference] <EntityReference> [[-Name] <String>] [[-DataDescription] <String>] [[-PresentationDescription] <String>] [[-Description] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmChart -ChartReference $chartRef -Name "Updated Revenue Chart";
``` 



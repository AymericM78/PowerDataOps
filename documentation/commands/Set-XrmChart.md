# Command : `Set-XrmChart` 

## Description

**Update a chart in Microsoft Dataverse.** : Update an existing savedqueryvisualization record (system chart).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ChartReference|EntityReference|2|true||EntityReference of the savedqueryvisualization to update.
Name|String|3|false||Updated chart display name.
Labels|Hashtable|4|false||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). -Name takes precedence if both are provided.
LanguageCode|Int32|5|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
DataDescription|String|6|false||Updated data description XML.
PresentationDescription|String|7|false||Updated presentation description XML.
Description|String|8|false||Updated description.
SolutionUniqueName|String|9|false||Unmanaged solution unique name. When provided, the updated chart is automatically added to this solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated savedqueryvisualization record.

## Usage

```Powershell 
Set-XrmChart [[-XrmClient] <ServiceClient>] [-ChartReference] <EntityReference> [[-Name] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] [[-DataDescription] <String>] [[-PresentationDescription] <String>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmChart -ChartReference $chartRef -Name "Updated Revenue Chart";
Set-XrmChart -ChartReference $chartRef -DataDescription $newXml -SolutionUniqueName "MySolution";
``` 



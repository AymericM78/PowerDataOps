# Command : `Upsert-XrmChart` 

## Description

**Create or update a chart in Microsoft Dataverse.** : Upsert a savedqueryvisualization record (system chart) by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||Chart (savedqueryvisualization) Id used as the upsert key.
EntityLogicalName|String|3|true||Table / Entity logical name the chart belongs to.
Name|String|4|true||Chart display name.
DataDescription|String|5|true||Data description XML defining the chart data source.
PresentationDescription|String|6|true||Presentation description XML defining the chart visual.
Description|String|7|false||Chart description.
SolutionUniqueName|String|8|false||Unmanaged solution unique name. When provided, the chart is added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedqueryvisualization record.

## Usage

```Powershell 
Upsert-XrmChart [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-EntityLogicalName] <String> [-Name] <String> [-DataDescription] <String> 
[-PresentationDescription] <String> [[-Description] <String>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmChart -Id $chartId -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml -SolutionUniqueName "MySolution";
``` 



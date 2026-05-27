# Command : `Upsert-XrmChart` 

## Description

**Create or update a chart in Microsoft Dataverse.** : Upsert a savedqueryvisualization record (system chart) by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||Chart (savedqueryvisualization) Id used as the upsert key.
EntityLogicalName|String|named|true||Table / Entity logical name the chart belongs to.
Name|String|named|true||Chart display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Revenue"; 1036 = "Chiffre d'affaires" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
DataDescription|String|named|true||Data description XML defining the chart data source.
PresentationDescription|String|named|true||Presentation description XML defining the chart visual.
Description|String|named|false||Chart description.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the chart is added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedqueryvisualization record.

## Usage

```Powershell 
Upsert-XrmChart [-XrmClient <ServiceClient>] -Id <Guid> -EntityLogicalName <String> -Name <String> [-LanguageCode <Int32>] -DataDescription <String> 
-PresentationDescription <String> [-Description <String>] [-SolutionUniqueName <String>] [<CommonParameters>]

Upsert-XrmChart [-XrmClient <ServiceClient>] -Id <Guid> -EntityLogicalName <String> -Labels <Hashtable> [-LanguageCode <Int32>] -DataDescription <String> 
-PresentationDescription <String> [-Description <String>] [-SolutionUniqueName <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmChart -Id $chartId -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml -SolutionUniqueName "MySolution";
``` 



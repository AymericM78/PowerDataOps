# Command : `New-XrmChart` 

## Description

**Create a new chart in Microsoft Dataverse.** : Create a new savedqueryvisualization record (system chart).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name the chart belongs to.
Name|String|3|true||Chart display name.
DataDescription|String|4|true||Data description XML defining the chart data source.
PresentationDescription|String|5|true||Presentation description XML defining the chart visual.
Description|String|6|false||Chart description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created savedqueryvisualization record.

## Usage

```Powershell 
New-XrmChart [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-Name] <String> [-DataDescription] <String> [-PresentationDescription] <String> [[-Description] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = New-XrmChart -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml;
``` 



# Command : `Get-XrmCharts` 

## Description

**Retrieve chart records from Microsoft Dataverse.** : Get savedqueryvisualization records (system charts) filtered by entity logical name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name to filter charts.
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
Microsoft.Xrm.Sdk.Entity[]. Array of savedqueryvisualization records.

## Usage

```Powershell 
Get-XrmCharts [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$charts = Get-XrmCharts -EntityLogicalName "account";
``` 



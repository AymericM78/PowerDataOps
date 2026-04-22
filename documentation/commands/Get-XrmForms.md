# Command : `Get-XrmForms` 

## Description

**Retrieve form records from Microsoft Dataverse.** : Get systemform records (forms) filtered by entity logical name and optionally by form type.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Table / Entity logical name to filter forms. Optional.
FormType|Int32|3|false|0|Form type filter (0=Dashboard, 2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView). Optional.
Columns|String[]|4|false|@("*")|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject[]. Array of systemform records (XrmObject).

## Usage

```Powershell 
Get-XrmForms [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-FormType] <Int32>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$forms = Get-XrmForms -EntityLogicalName "account";
$mainForms = Get-XrmForms -EntityLogicalName "account" -FormType 2;
$dashboards = Get-XrmForms -FormType 0;
``` 



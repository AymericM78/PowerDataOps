# Command : `Get-XrmForms` 

## Description

**Retrieve form records from Microsoft Dataverse.** : Get systemform records (forms) filtered by entity logical name and optionally by form type.
Use -Unpublished to also retrieve forms that are in draft state.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|false||Table / Entity logical name to filter forms. Optional.
FormType|Int32[]|3|false||Form type filter, one value or several (0=Dashboard, 2=Main, 5=Mobile, 6=QuickCreate, 7=QuickView, 10=InteractiveExperience dashboard). Optional.
Columns|String[]|4|false|@("*")|Specify expected columns to retrieve. (Default : all columns)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include forms in draft (unpublished) state.
Without this switch only published forms are returned.

## Outputs
PSCustomObject[]. Array of systemform records (XrmObject).

## Usage

```Powershell 
Get-XrmForms [[-XrmClient] <ServiceClient>] [[-EntityLogicalName] <String>] [[-FormType] <Int32[]>] [[-Columns] <String[]>] [-Unpublished] [<CommonParameters>]
``` 

## Examples

```Powershell 
$forms = Get-XrmForms -EntityLogicalName "account";
$mainForms = Get-XrmForms -EntityLogicalName "account" -FormType 2;
$dashboards = Get-XrmForms -FormType 0;
``` 


```Powershell 
# Include unpublished drafts
$allForms = Get-XrmForms -EntityLogicalName "account" -Unpublished;
``` 



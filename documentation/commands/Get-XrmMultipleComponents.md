# Command : `Get-XrmMultipleComponents` 

## Description

**Retrieve multiple component records with optional unpublished support.** : Executes a QueryBase against Microsoft Dataverse. When -Unpublished is specified,
uses RetrieveUnpublishedMultiple to include draft components (forms, views, commands,
charts, sitemaps, app modules, etc.); otherwise delegates to Get-XrmMultipleRecords
(with full pagination support).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Query|QueryBase|2|true||Query that selects and filters data from a Microsoft Dataverse table. (QueryBase)
Unpublished|SwitchParameter|named|false|False|When specified, uses RetrieveUnpublishedMultiple to include components in draft
(unpublished) state. Without this switch only published components are returned.

## Outputs
PSCustomObject[]. Records converted to XrmObjects.

## Usage

```Powershell 
Get-XrmMultipleComponents [[-XrmClient] <ServiceClient>] [-Query] <QueryBase> [-Unpublished] [<CommonParameters>]
``` 

## Examples

```Powershell 
$query = New-XrmQueryExpression -LogicalName "systemform" -Columns "*";
$forms = $xrmClient | Get-XrmMultipleComponents -Query $query -Unpublished;
``` 


```Powershell 
$query = New-XrmQueryExpression -LogicalName "savedquery" -Columns "*";
$views = $xrmClient | Get-XrmMultipleComponents -Query $query;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMultipleComponents.md



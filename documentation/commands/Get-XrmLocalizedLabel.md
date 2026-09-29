# Command : `Get-XrmLocalizedLabel` 

## Description

**Retrieve the labels of a localizable column of a row, in every language.** : Read the translations of a localizable text column of a row (RetrieveLocLabels): e.g. the name of a view, a form, an app, a solution or a publisher.
Reading counterpart of Set-XrmLocalizedLabel. Returns the Label (one LocalizedLabel per language), or a hashtable @{ languageCode = text } with AsHashtable, ready for Set-XrmLocalizedLabel -Labels.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityMoniker|EntityReference|2|true||Reference of the row.
AttributeName|String|3|true||Localizable column logical name (e.g. "name", "friendlyname").
IncludeUnpublished|Boolean|4|false|True|Read the unpublished labels. (Default: true)
AsHashtable|SwitchParameter|named|false|False|Return @{ languageCode = text } instead of the Label.

## Outputs
Microsoft.Xrm.Sdk.Label, or Hashtable with AsHashtable.

## Usage

```Powershell 
Get-XrmLocalizedLabel [[-XrmClient] <ServiceClient>] [-EntityMoniker] <EntityReference> [-AttributeName] <String> [[-IncludeUnpublished] <Boolean>] [-AsHashtable] [<CommonParameters>]
``` 

## Examples

```Powershell 
$labels = Get-XrmLocalizedLabel -XrmClient $xrmClient -EntityMoniker $view.Reference -AttributeName "name" -AsHashtable;
$labels[1036];
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmLocalizedLabel.md



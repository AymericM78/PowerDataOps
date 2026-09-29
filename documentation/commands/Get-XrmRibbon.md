# Command : `Get-XrmRibbon` 

## Description

**Retrieve the ribbon customizations (RibbonDiffXml) of several tables with one solution export.** : Export an unmanaged solution holding the tables and read the RibbonDiffXml of each one in customizations.xml.
Without SolutionUniqueName, a temporary solution holding the tables is created with the publisher given by PublisherUniqueName (or the organization default publisher), exported, then removed, even on failure.
Returns one object per table: EntityLogicalName, RibbonDiffXml (XmlElement, $null when the table has none).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String[]|2|true||Logical names of the tables.
SolutionUniqueName|String|3|false||Existing unmanaged solution holding the tables, exported instead of a temporary one.
PublisherUniqueName|String|4|false||Publisher of the temporary solution. Ignored when SolutionUniqueName is given. (Default: organization default publisher)
OutputPath|String|5|false|[System.IO.Path]::GetTempPath()|Work folder for the export. (Default: TEMP folder)

## Outputs
PSCustomObject[]. EntityLogicalName, RibbonDiffXml.

## Usage

```Powershell 
Get-XrmRibbon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String[]> [[-SolutionUniqueName] <String>] [[-PublisherUniqueName] <String>] [[-OutputPath] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ribbons = Get-XrmRibbon -XrmClient $xrmClient -EntityLogicalName "account", "contact", "lead";
$ribbons | ForEach-Object { "$($_.EntityLogicalName): $($_.RibbonDiffXml.CustomActions.ChildNodes.Count) custom actions" };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRibbon.md



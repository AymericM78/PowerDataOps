# Command : `Export-XrmRibbon` 

## Description

**Export the ribbon customization XML for a table.** : Export the RibbonDiffXml for a specific table by creating a temporary solution containing the table,
exporting the solution, extracting the customizations.xml, and parsing the RibbonDiffXml node.
This allows reading and modifying classic ribbon customizations programmatically.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the table whose ribbon to export.
SolutionUniqueName|String|3|false||Existing solution unique name containing the table. If provided, exports from this solution instead of creating a temporary one.
OutputPath|String|4|false|$env:TEMP|Folder path where extracted files will be stored. Optional. Defaults to temp folder.

## Outputs
System.Xml.XmlElement. The RibbonDiffXml node for the specified entity.

## Usage

```Powershell 
Export-XrmRibbon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-SolutionUniqueName] <String>] [[-OutputPath] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
$ribbonXml = Export-XrmRibbon -EntityLogicalName "contact" -SolutionUniqueName "MySolution";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/customize-commands-ribbon



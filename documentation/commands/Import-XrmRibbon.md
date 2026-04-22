# Command : `Import-XrmRibbon` 

## Description

**Import ribbon customization XML for a table.** : Import a modified RibbonDiffXml for a specific table by creating a temporary solution containing the table,
exporting the solution, replacing the RibbonDiffXml node in customizations.xml, re-zipping, and importing.
This allows modifying classic ribbon customizations (commands, display rules, enable rules) programmatically.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the table whose ribbon to update.
RibbonDiffXml|String|3|true||The RibbonDiffXml content as string or XmlElement containing CustomActions, CommandDefinitions, RuleDefinitions, etc.
SolutionUniqueName|String|4|false||Existing solution unique name to use for import. If provided, uses this solution instead of creating a temporary one.
Publish|Boolean|5|false|True|Publish customizations after import. Default: true.

## Outputs
System.Void.

## Usage

```Powershell 
Import-XrmRibbon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-RibbonDiffXml] <String> [[-SolutionUniqueName] <String>] [[-Publish] 
<Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
# Modify $ribbonXml as needed...
Import-XrmRibbon -EntityLogicalName "account" -RibbonDiffXml $ribbonXml.OuterXml;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/customize-commands-ribbon



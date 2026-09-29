# Command : `Import-XrmRibbon` 

## Description

**Import ribbon customization XML for a table.** : Import a modified RibbonDiffXml for a specific table by creating a temporary solution containing the table,
exporting the solution, replacing the RibbonDiffXml node in customizations.xml, re-zipping, and importing.
This allows modifying classic ribbon customizations (commands, display rules, enable rules) programmatically.
The temporary solution uses the publisher given by PublisherUniqueName, or the organization default publisher (publisher of the Default solution). It is removed at the end, even on failure.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the table whose ribbon to update.
RibbonDiffXml|Object|3|true||The RibbonDiffXml content, as a string or as an XmlElement (e.g. the output of Export-XrmRibbon), containing CustomActions, CommandDefinitions, RuleDefinitions, etc.
SolutionUniqueName|String|4|false||Existing solution unique name to use for import. If provided, uses this solution instead of creating a temporary one.
Publish|Boolean|5|false|True|Publish customizations after import. Default: true.
PublisherUniqueName|String|6|false||Publisher of the temporary solution. Ignored when SolutionUniqueName is given. (Default: organization default publisher)

## Outputs
System.Void.

## Usage

```Powershell 
Import-XrmRibbon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-RibbonDiffXml] <Object> [[-SolutionUniqueName] <String>] [[-Publish] <Boolean>] [[-PublisherUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
# Modify $ribbonXml as needed...
Import-XrmRibbon -EntityLogicalName "account" -RibbonDiffXml $ribbonXml;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/customize-commands-ribbon



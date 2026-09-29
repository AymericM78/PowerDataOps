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
TargetSolutionUniqueName|String|7|false||Unmanaged solution to add the table to after the import (the ribbon belongs to the table component), distinct from the temporary or exported solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Import-XrmRibbon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-RibbonDiffXml] <Object> [[-SolutionUniqueName] <String>] [[-Publish] <Boolean>] [[-PublisherUniqueName] <String>] [[-TargetSolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
# Modify $ribbonXml as needed...
Import-XrmRibbon -EntityLogicalName "account" -RibbonDiffXml $ribbonXml;
``` 


```Powershell 
# Temporary solution with the publisher of the target solution, table added to the target afterwards
Import-XrmRibbon -XrmClient $xrmClient -EntityLogicalName "account" -RibbonDiffXml $ribbonXml -PublisherUniqueName "contoso" -TargetSolutionUniqueName "ContosoCore";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Import-XrmRibbon.md



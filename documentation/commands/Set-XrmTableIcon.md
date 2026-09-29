# Command : `Set-XrmTableIcon` 

## Description

**Assign an SVG webresource icon to a Dataverse table.** : Validate a Dataverse SVG webresource, assign it to the table IconVectorName metadata property,
update the table metadata, and optionally publish the customization.
A table that is not customizable raises an error, or is skipped with a warning when SkipSystemTables is set.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the Dataverse table that should receive the SVG icon.
EntityMetadataId|Guid|3|false||Table metadata unique identifier. Optional: resolved from EntityLogicalName.
WebResourceName|String|4|true||Name of the Dataverse SVG webresource to assign as the table icon.
SolutionUniqueName|String|5|false||Solution unique name context for the metadata update.
PublishChanges|Boolean|6|false|True|Whether to publish the table customization after updating the icon. Default: true.
SkipSystemTables|SwitchParameter|named|false|False|Skip a table that is not customizable (warning, nothing returned) instead of raising an error.

## Outputs
Microsoft.Xrm.Sdk.Metadata.EntityMetadata. The table metadata read after the update.

## Usage

```Powershell 
Set-XrmTableIcon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-EntityMetadataId] <Guid>] [-WebResourceName] <String> [[-SolutionUniqueName] <String>] [[-PublishChanges] <Boolean>] [-SkipSystemTables] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmTableIcon -EntityLogicalName "account" -WebResourceName "new_accounticon.svg";
``` 


```Powershell 
$tables | ForEach-Object { Set-XrmTableIcon -XrmClient $xrmClient -EntityLogicalName $_ -WebResourceName "new_icon.svg" -PublishChanges $false -SkipSystemTables };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmTableIcon.md



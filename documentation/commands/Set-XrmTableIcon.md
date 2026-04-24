# Command : `Set-XrmTableIcon` 

## Description

**Assign an SVG webresource icon to a Dataverse table.** : Validate a Dataverse SVG webresource, assign it to the table vector icon metadata, update the table, and optionally publish the change.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Dataverse connection.
EntityLogicalName|String|2|true||Logical name of the Dataverse table that should receive the SVG icon.
WebResourceName|String|3|true||Name of the Dataverse SVG webresource to assign as the table icon.
SolutionUniqueName|String|4|false||Solution unique name context for the metadata update.
PublishChanges|Boolean|5|false|True|Whether to publish the table customization after updating the icon.

## Outputs
Microsoft.Xrm.Sdk.Metadata.EntityMetadata. The updated table metadata.

## Usage

```Powershell 
Set-XrmTableIcon [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-WebResourceName] <String> [[-SolutionUniqueName] <String>] [[-PublishChanges] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmTableIcon -EntityLogicalName "account" -WebResourceName "new_accounticon.svg";

Set-XrmTableIcon -EntityLogicalName "new_project" -WebResourceName "new_projecticon.svg" -PublishChanges $false;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md
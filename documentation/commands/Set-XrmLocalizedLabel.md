# Command : `Set-XrmLocalizedLabel` 

## Description

**Set localized labels on a Dataverse metadata component.** : Update localized labels on a metadata attribute, entity, option value, or relationship using the SetLocLabels SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityMoniker|EntityReference|2|true||EntityReference identifying the metadata component (e.g. EntityReference to an AttributeMetadata, EntityMetadata, etc.).
AttributeName|String|3|true||The attribute within the metadata component to set the label for (e.g. "DisplayName", "Description").
Labels|Hashtable|4|true||Hashtable of language code to label text. Example: @{ 1033 = "Account"; 1036 = "Compte" }

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The SetLocLabels response.

## Usage

```Powershell 
Set-XrmLocalizedLabel [[-XrmClient] <ServiceClient>] [-EntityMoniker] <EntityReference> [-AttributeName] <String> [-Labels] <Hashtable> 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$entityRef = New-XrmEntityReference -LogicalName "EntityMetadata" -Id $entityMetadataId;
Set-XrmLocalizedLabel -EntityMoniker $entityRef -AttributeName "DisplayName" -Labels @{ 1033 = "Account"; 1036 = "Compte" };
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/setloclabels



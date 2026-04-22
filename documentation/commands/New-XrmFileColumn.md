# Command : `New-XrmFileColumn` 

## Description

**Build a FileAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.FileAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
MaxSizeInKb|Int32|4|false|10240|Max file size in kilobytes.
Description|String|5|false||Column description label.
RequiredLevel|AttributeRequiredLevel|6|false|None|Required level. Default: None.
LanguageCode|Int32|7|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.FileAttributeMetadata.

## Usage

```Powershell 
New-XrmFileColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [[-MaxSizeInKb] <Int32>] [[-Description] <String>] 
[[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmFileColumn -LogicalName "new_contract" -SchemaName "new_Contract" -DisplayName "Contract" -MaxSizeInKb 10240;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/file-column-data



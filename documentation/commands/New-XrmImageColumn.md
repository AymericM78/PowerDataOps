# Command : `New-XrmImageColumn` 

## Description

**Build an ImageAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
MaxSizeInKb|Int32|4|false|10240|Max image size in kilobytes.
CanStoreFullImage|SwitchParameter|named|false|False|Indicates whether the full image should be stored.
IsPrimaryImage|SwitchParameter|named|false|False|Indicates whether the column is the primary image.
Description|String|5|false||Column description label.
RequiredLevel|AttributeRequiredLevel|6|false|None|Required level. Default: None.
LanguageCode|Int32|7|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata.

## Usage

```Powershell 
New-XrmImageColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [[-MaxSizeInKb] <Int32>] [-CanStoreFullImage] [-IsPrimaryImage] 
[[-Description] <String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmImageColumn -LogicalName "new_profileimage" -SchemaName "new_ProfileImage" -DisplayName "Profile Image" -MaxSizeInKb 10240 -CanStoreFullImage;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/image-column-data



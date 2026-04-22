# Command : `New-XrmMemoColumn` 

## Description

**Build a MemoAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
MaxLength|Int32|4|true|0|Maximum text length.
Description|String|5|false||Column description label.
RequiredLevel|AttributeRequiredLevel|6|false|None|Required level. Default: None.
LanguageCode|Int32|7|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata.

## Usage

```Powershell 
New-XrmMemoColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [-MaxLength] <Int32> [[-Description] <String>] [[-RequiredLevel] 
{None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmMemoColumn -LogicalName "new_notes" -SchemaName "new_Notes" -DisplayName "Notes" -MaxLength 4000;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns



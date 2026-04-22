# Command : `New-XrmAutoNumberColumn` 

## Description

**Build an auto-number StringAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata object
with AutoNumberFormat, ready for Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
AutoNumberFormat|String|4|true||Auto-number format string.
MaxLength|Int32|5|false|100|Maximum text length. Default: 100.
Description|String|6|false||Column description label.
RequiredLevel|AttributeRequiredLevel|7|false|None|Required level. Default: None.
LanguageCode|Int32|8|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata.

## Usage

```Powershell 
New-XrmAutoNumberColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [-AutoNumberFormat] <String> [[-MaxLength] <Int32>] 
[[-Description] <String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmAutoNumberColumn -LogicalName "new_number" -SchemaName "new_Number" -DisplayName "Number" -AutoNumberFormat "ORD-{SEQNUM:5}";
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-auto-number-fields



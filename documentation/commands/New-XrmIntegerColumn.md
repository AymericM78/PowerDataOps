# Command : `New-XrmIntegerColumn` 

## Description

**Build an IntegerAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
MinValue|Int32|4|false|0|Minimum accepted value.
MaxValue|Int32|5|false|2147483647|Maximum accepted value.
Description|String|6|false||Column description label.
RequiredLevel|AttributeRequiredLevel|7|false|None|Required level. Default: None.
LanguageCode|Int32|8|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.IntegerAttributeMetadata.

## Usage

```Powershell 
New-XrmIntegerColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [[-MinValue] <Int32>] [[-MaxValue] <Int32>] [[-Description] 
<String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmIntegerColumn -LogicalName "new_score" -SchemaName "new_Score" -DisplayName "Score" -MinValue 0 -MaxValue 100;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns



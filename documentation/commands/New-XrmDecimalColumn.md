# Command : `New-XrmDecimalColumn` 

## Description

**Build a DecimalAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.DecimalAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
Precision|Int32|4|false|2|Decimal precision.
MinValue|Decimal|5|false|0|Minimum accepted value.
MaxValue|Decimal|6|false|1000000000|Maximum accepted value.
Description|String|7|false||Column description label.
RequiredLevel|AttributeRequiredLevel|8|false|None|Required level. Default: None.
LanguageCode|Int32|9|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.DecimalAttributeMetadata.

## Usage

```Powershell 
New-XrmDecimalColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [[-Precision] <Int32>] [[-MinValue] <Decimal>] [[-MaxValue] 
<Decimal>] [[-Description] <String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmDecimalColumn -LogicalName "new_ratio" -SchemaName "new_Ratio" -DisplayName "Ratio" -Precision 2 -MinValue 0 -MaxValue 100;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns



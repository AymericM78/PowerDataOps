# Command : `New-XrmBooleanColumn` 

## Description

**Build a BooleanAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
DefaultValue|Boolean|4|false|False|Default boolean value.
TrueLabel|String|5|false|Yes|Label used for the true option. Default: Yes.
FalseLabel|String|6|false|No|Label used for the false option. Default: No.
Description|String|7|false||Column description label.
RequiredLevel|AttributeRequiredLevel|8|false|None|Required level. Default: None.
LanguageCode|Int32|9|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata.

## Usage

```Powershell 
New-XrmBooleanColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [[-DefaultValue] <Boolean>] [[-TrueLabel] <String>] 
[[-FalseLabel] <String>] [[-Description] <String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] 
<Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmBooleanColumn -LogicalName "new_enabled" -SchemaName "new_Enabled" -DisplayName "Enabled" -DefaultValue $false -TrueLabel "Active" -FalseLabel "Inactive";
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns



# Command : `New-XrmStringColumn` 

## Description

**Build a StringAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
MaxLength|Int32|4|true|0|Maximum text length.
Format|String|5|false|Text|Text format. Default: Text.
Description|String|6|false||Column description label.
RequiredLevel|AttributeRequiredLevel|7|false|None|Required level. Default: None.
LanguageCode|Int32|8|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata.

## Usage

```Powershell 
New-XrmStringColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [-MaxLength] <Int32> [[-Format] <String>] [[-Description] 
<String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmStringColumn -LogicalName "new_code" -SchemaName "new_Code" -DisplayName "Code" -MaxLength 100 -Format Email;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns



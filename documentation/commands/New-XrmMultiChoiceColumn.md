# Command : `New-XrmMultiChoiceColumn` 

## Description

**Build a MultiSelectPicklistAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata object
referencing a global option set or defining local options, ready for Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|named|true||Column logical name.
SchemaName|String|named|true||Column schema name.
DisplayName|String|named|true||Column display name.
GlobalOptionSetName|String|named|true||Global option set name.
LocalOptions|String[]|named|true||Local option labels to embed directly in the column metadata.
Options|OptionMetadata[]|named|true||Local option metadata objects to embed directly in the column metadata.
StartingValue|Int32|named|false|100000000|Starting integer value for local options. Default: 100000000.
Description|String|named|false||Column description label.
RequiredLevel|AttributeRequiredLevel|named|false|None|Required level. Default: None.
LanguageCode|Int32|named|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata.

## Usage

```Powershell 
New-XrmMultiChoiceColumn -LogicalName <String> -SchemaName <String> -DisplayName <String> -GlobalOptionSetName <String> [-Description <String>] 
[-RequiredLevel {None | SystemRequired | ApplicationRequired | Recommended}] [-LanguageCode <Int32>] [<CommonParameters>]

New-XrmMultiChoiceColumn -LogicalName <String> -SchemaName <String> -DisplayName <String> -LocalOptions <String[]> [-StartingValue <Int32>] [-Description 
<String>] [-RequiredLevel {None | SystemRequired | ApplicationRequired | Recommended}] [-LanguageCode <Int32>] [<CommonParameters>]

New-XrmMultiChoiceColumn -LogicalName <String> -SchemaName <String> -DisplayName <String> -Options <OptionMetadata[]> [-Description <String>] 
[-RequiredLevel {None | SystemRequired | ApplicationRequired | Recommended}] [-LanguageCode <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmMultiChoiceColumn -LogicalName "new_tags" -SchemaName "new_Tags" -DisplayName "Tags" -GlobalOptionSetName "new_tagchoices";
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 


```Powershell 
$attribute = New-XrmMultiChoiceColumn -LogicalName "new_preferences" -SchemaName "new_Preferences" -DisplayName "Preferences" -LocalOptions @("Phone", "Email", "SMS");
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 


```Powershell 
$options = @(
(New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Phone") -Color "#CDDAFD"),
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "Email") -Color "#FCE1E4")
);
$attribute = New-XrmMultiChoiceColumn -LogicalName "new_preferences" -SchemaName "new_Preferences" -DisplayName "Preferences" -Options $options;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/multi-select-picklist



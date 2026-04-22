# Command : `New-XrmChoiceColumn` 

## Description

**Build a PicklistAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata object
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
Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata.

## Usage

```Powershell 
New-XrmChoiceColumn -LogicalName <String> -SchemaName <String> -DisplayName <String> -GlobalOptionSetName <String> [-Description <String>] 
[-RequiredLevel {None | SystemRequired | ApplicationRequired | Recommended}] [-LanguageCode <Int32>] [<CommonParameters>]

New-XrmChoiceColumn -LogicalName <String> -SchemaName <String> -DisplayName <String> -LocalOptions <String[]> [-StartingValue <Int32>] [-Description 
<String>] [-RequiredLevel {None | SystemRequired | ApplicationRequired | Recommended}] [-LanguageCode <Int32>] [<CommonParameters>]

New-XrmChoiceColumn -LogicalName <String> -SchemaName <String> -DisplayName <String> -Options <OptionMetadata[]> [-Description <String>] [-RequiredLevel 
{None | SystemRequired | ApplicationRequired | Recommended}] [-LanguageCode <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmChoiceColumn -LogicalName "new_status" -SchemaName "new_Status" -DisplayName "Status" -GlobalOptionSetName "new_statuschoices";
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 


```Powershell 
$attribute = New-XrmChoiceColumn -LogicalName "new_priority" -SchemaName "new_Priority" -DisplayName "Priority" -LocalOptions @("Low", "Medium", "High");
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 


```Powershell 
$options = @(
(New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
);
$attribute = New-XrmChoiceColumn -LogicalName "new_priority" -SchemaName "new_Priority" -DisplayName "Priority" -Options $options;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/webapi/reference/picklistattributemetadata



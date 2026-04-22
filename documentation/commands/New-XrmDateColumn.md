# Command : `New-XrmDateColumn` 

## Description

**Build a DateTimeAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata object
that can be passed to Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
Format|String|4|false|DateOnly|Date format. DateOnly or DateAndTime.
Behavior|String|5|false||DateTime behavior. UserLocal, DateOnly, or TimeZoneIndependent.
Description|String|6|false||Column description label.
RequiredLevel|AttributeRequiredLevel|7|false|None|Required level. Default: None.
LanguageCode|Int32|8|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata.

## Usage

```Powershell 
New-XrmDateColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [[-Format] <String>] [[-Behavior] <String>] [[-Description] 
<String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmDateColumn -LogicalName "new_startdate" -SchemaName "new_StartDate" -DisplayName "Start Date" -Format DateAndTime -Behavior TimeZoneIndependent;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/behavior-format-date-time-attribute



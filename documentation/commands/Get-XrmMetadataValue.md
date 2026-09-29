# Command : `Get-XrmMetadataValue` 

## Description

**Read a value from a metadata object.** : Read a property of a metadata object (EntityMetadata, AttributeMetadata, RelationshipMetadata, OptionSetMetadata...) as a plain value.
A managed property (BooleanManagedProperty, AttributeRequiredLevelManagedProperty...) gives its Value, or its CanBeChanged flag with CanBeChanged.
A Label gives the text for LanguageCode, or the user label when LanguageCode is not given.
Property accepts a dotted path (e.g. "OptionSet.Name"). A missing intermediate value gives $null.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Metadata|Object|1|true||Metadata object to read.
Property|String|2|true||Property name, or dotted path of property names.
CanBeChanged|SwitchParameter|named|false|False|Return the CanBeChanged flag of a managed property instead of its value.
LanguageCode|Int32|3|false|0|Language of the text to return when the property is a Label. (Default: user localized label)

## Outputs
System.Object. The plain value.

## Usage

```Powershell 
Get-XrmMetadataValue [-Metadata] <Object> [-Property] <String> [-CanBeChanged] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$entityMetadata = Get-XrmEntityMetadata -LogicalName "account";
$isAuditEnabled = Get-XrmMetadataValue -Metadata $entityMetadata -Property "IsAuditEnabled";
$canChangeAudit = Get-XrmMetadataValue -Metadata $entityMetadata -Property "IsAuditEnabled" -CanBeChanged;
``` 


```Powershell 
$frenchName = $entityMetadata | Get-XrmMetadataValue -Property "DisplayName" -LanguageCode 1036;
``` 


```Powershell 
$requiredLevel = $attributeMetadata | Get-XrmMetadataValue -Property "RequiredLevel";   # AttributeRequiredLevel enum value
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMetadataValue.md



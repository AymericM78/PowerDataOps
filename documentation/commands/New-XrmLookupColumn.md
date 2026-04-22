# Command : `New-XrmLookupColumn` 

## Description

**Build a LookupAttributeMetadata for a Dataverse column.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata object
for relationship-based creation requests such as Add-XrmOneToManyRelationship
or Add-XrmPolymorphicLookup. This constructor does not create the lookup
through Add-XrmColumn because Dataverse requires a relationship creation
request for lookup attributes.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Column logical name.
SchemaName|String|2|true||Column schema name.
DisplayName|String|3|true||Column display name.
Targets|String[]|4|true||Referenced table logical names.
Description|String|5|false||Column description label.
RequiredLevel|AttributeRequiredLevel|6|false|None|Required level. Default: None.
LanguageCode|Int32|7|false|1033|Label language code. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata.

## Usage

```Powershell 
New-XrmLookupColumn [-LogicalName] <String> [-SchemaName] <String> [-DisplayName] <String> [-Targets] <String[]> [[-Description] <String>] 
[[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attribute = New-XrmLookupColumn -LogicalName "new_accountid" -SchemaName "new_AccountId" -DisplayName "Account" -Targets @("account");
$relationship = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
$relationship.SchemaName = "new_account_contact";
$relationship.ReferencedEntity = "account";
$relationship.ReferencingEntity = "contact";
$relationship.ReferencedAttribute = "accountid";
Add-XrmOneToManyRelationship -OneToManyRelationship $relationship -Lookup $attribute;
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/create-edit-entity-relationships



# Command : `Add-XrmTable` 

## Description

**Create a new table in Microsoft Dataverse.** : Create a new entity / table using CreateEntityRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name.
DisplayName|String|3|true||Display name for the table.
PluralName|String|4|true||Plural display name for the table.
Description|String|5|false||Table description.
OwnershipType|OwnershipTypes|6|false|UserOwned|Ownership type (UserOwned or OrganizationOwned). Default: UserOwned.
HasNotes|Boolean|7|false|False|Whether the table has notes enabled. Default: false.
HasActivities|Boolean|8|false|False|Whether the table has activities enabled. Default: false.
IsActivity|Boolean|9|false|False|Whether the table is an activity entity. Default: false.
PrimaryAttributeSchemaName|String|10|true||Schema name for the primary attribute.
PrimaryAttributeDisplayName|String|11|true||Display name for the primary attribute.
PrimaryAttributeMaxLength|Int32|12|false|100|Max length of the primary attribute. Default: 100.
SolutionUniqueName|String|13|false||Solution unique name to add the table to.
LanguageCode|Int32|14|false|1033|Language code for labels. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateEntity response.

## Usage

```Powershell 
Add-XrmTable [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [-DisplayName] <String> [-PluralName] <String> [[-Description] <String>] 
[[-OwnershipType] {None | UserOwned | TeamOwned | BusinessOwned | OrganizationOwned | BusinessParented | Filtered}] [[-HasNotes] <Boolean>] 
[[-HasActivities] <Boolean>] [[-IsActivity] <Boolean>] [-PrimaryAttributeSchemaName] <String> [-PrimaryAttributeDisplayName] <String> 
[[-PrimaryAttributeMaxLength] <Int32>] [[-SolutionUniqueName] <String>] [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = Add-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects" -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";
``` 



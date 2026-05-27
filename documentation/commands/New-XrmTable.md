# Command : `New-XrmTable` 

## Description

**Build an EntityMetadata object for a Dataverse table.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.EntityMetadata object
that can be passed to Add-XrmTable.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|false||Table / Entity logical name.
DisplayName|String|2|false||Display name for the table.
PluralName|String|3|false||Plural display name for the table.
Description|String|4|false||Table description.
OwnershipType|OwnershipTypes|5|false|UserOwned|Ownership type (UserOwned or OrganizationOwned). Default: UserOwned.
HasNotes|Boolean|6|false|False|Whether the table has notes enabled. Default: false.
HasActivities|Boolean|7|false|False|Whether the table has activities enabled. Default: false.
IsActivity|Boolean|8|false|False|Whether the table is an activity entity. Default: false.
IsAuditEnabled|Boolean|9|false|False|Whether auditing is enabled on the table. Default: false.
LanguageCode|Int32|10|false|1033|Language code for labels. Default: 1033.
IconVectorName|String|11|false||Name of the vector icon to use for the table.

## Outputs
Microsoft.Xrm.Sdk.Metadata.EntityMetadata.

## Usage

```Powershell 
New-XrmTable [[-LogicalName] <String>] [[-DisplayName] <String>] [[-PluralName] <String>] [[-Description] <String>] [[-OwnershipType] {None | UserOwned | 
TeamOwned | BusinessOwned | OrganizationOwned | BusinessParented | Filtered}] [[-HasNotes] <Boolean>] [[-HasActivities] <Boolean>] [[-IsActivity] 
<Boolean>] [[-IsAuditEnabled] <Boolean>] [[-LanguageCode] <Int32>] [[-IconVectorName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$metadata = New-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects";
Add-XrmTable -EntityMetadata $metadata -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";
``` 



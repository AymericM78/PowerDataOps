# Command : `Add-XrmTable` 

## Description

**Create a new table in Microsoft Dataverse.** : Create a new entity / table using CreateEntityRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name.
DisplayName|String|3|false||Display name for the table. DisplayName or DisplayNameLabels is required.
PluralName|String|4|false||Plural display name for the table. PluralName or PluralNameLabels is required.
Description|String|5|false||Table description.
OwnershipType|OwnershipTypes|6|false|UserOwned|Ownership type (UserOwned or OrganizationOwned). Default: UserOwned.
HasNotes|Boolean|7|false|False|Whether the table has notes enabled. Default: false.
HasActivities|Boolean|8|false|False|Whether the table has activities enabled. Default: false.
IsActivity|Boolean|9|false|False|Whether the table is an activity entity. Default: false.
PrimaryAttributeSchemaName|String|10|true||Schema name for the primary attribute.
PrimaryAttributeDisplayName|String|11|false||Display name for the primary attribute. PrimaryAttributeDisplayName or PrimaryAttributeDisplayNameLabels is required.
PrimaryAttributeMaxLength|Int32|12|false|100|Max length of the primary attribute. Default: 100.
IsAuditEnabled|Boolean|13|false|False|Whether auditing is enabled on the table. Default: false.
SolutionUniqueName|String|14|false||Solution unique name to add the table to.
LanguageCode|Int32|15|false|1033|Language code for labels. Default: 1033.
DisplayNameLabels|Hashtable|16|false||Hashtable of language code to display name for multilingual labels. Takes precedence over -DisplayName. Example: @{ 1033 = "Project"; 1036 = "Projet" }
PluralNameLabels|Hashtable|17|false||Hashtable of language code to plural display name for multilingual labels. Takes precedence over -PluralName.
DescriptionLabels|Hashtable|18|false||Hashtable of language code to description for multilingual labels. Takes precedence over -Description.
PrimaryAttributeDisplayNameLabels|Hashtable|19|false||Hashtable of language code to primary attribute display name for multilingual labels. Takes precedence over -PrimaryAttributeDisplayName.
IconVectorName|String|20|false||Name of the vector icon to use for the table.
IsAvailableOffline|Boolean|21|false|False|Whether the table is available offline. An activity table requires IsAvailableOffline and HasNotes set to true (checked before sending).
IsQuickCreateEnabled|Boolean|22|false|False|Whether quick create forms are enabled.
IsConnectionsEnabled|Boolean|23|false|False|Whether connections are enabled.
IsDocumentManagementEnabled|Boolean|24|false|False|Whether SharePoint document management is enabled.
IsMailMergeEnabled|Boolean|25|false|False|Whether mail merge is enabled.
ChangeTrackingEnabled|Boolean|26|false|False|Whether change tracking is enabled.
SyncToExternalSearchIndex|Boolean|27|false|False|Whether the table is indexed by Dataverse search.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateEntity response.

## Usage

```Powershell 
Add-XrmTable [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [[-DisplayName] <String>] [[-PluralName] <String>] [[-Description] <String>] [[-OwnershipType] {None | UserOwned | TeamOwned | BusinessOwned | OrganizationOwned | BusinessParented | Filtered}] [[-HasNotes] <Boolean>] [[-HasActivities] <Boolean>] [[-IsActivity] <Boolean>] [-PrimaryAttributeSchemaName] <String> [[-PrimaryAttributeDisplayName] <String>] [[-PrimaryAttributeMaxLength] <Int32>] [[-IsAuditEnabled] <Boolean>] [[-SolutionUniqueName] <String>] [[-LanguageCode] <Int32>] [[-DisplayNameLabels] <Hashtable>] [[-PluralNameLabels] <Hashtable>] [[-DescriptionLabels] <Hashtable>] [[-PrimaryAttributeDisplayNameLabels] <Hashtable>] [[-IconVectorName] <String>] [[-IsAvailableOffline] <Boolean>] [[-IsQuickCreateEnabled] <Boolean>] [[-IsConnectionsEnabled] <Boolean>] [[-IsDocumentManagementEnabled] <Boolean>] [[-IsMailMergeEnabled] <Boolean>] [[-ChangeTrackingEnabled] <Boolean>] [[-SyncToExternalSearchIndex] <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = Add-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects" -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";
``` 


```Powershell 
$response = Add-XrmTable -LogicalName "new_project" -DisplayNameLabels @{ 1033 = "Project"; 1036 = "Projet" } -PluralNameLabels @{ 1033 = "Projects"; 1036 = "Projets" } -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayNameLabels @{ 1033 = "Name"; 1036 = "Nom" };
``` 


```Powershell 
# Activity table: the primary column of an activity is its subject
$response = Add-XrmTable -LogicalName "new_visit" -DisplayName "Visit" -PluralName "Visits" -IsActivity $true -HasNotes $true -IsAvailableOffline $true -IsQuickCreateEnabled $true -PrimaryAttributeSchemaName "Subject" -PrimaryAttributeDisplayName "Subject";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmTable.md



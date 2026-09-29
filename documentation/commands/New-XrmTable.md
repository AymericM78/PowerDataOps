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
DisplayNameLabels|Hashtable|11|false||Hashtable of language code to display name for multilingual labels. Takes precedence over -DisplayName. Example: @{ 1033 = "Project"; 1036 = "Projet" }
PluralNameLabels|Hashtable|12|false||Hashtable of language code to plural display name for multilingual labels. Takes precedence over -PluralName.
DescriptionLabels|Hashtable|13|false||Hashtable of language code to description for multilingual labels. Takes precedence over -Description.
IconVectorName|String|14|false||Name of the vector icon to use for the table.
IsAvailableOffline|Boolean|15|false|False|Whether the table is available offline.
IsQuickCreateEnabled|Boolean|16|false|False|Whether quick create forms are enabled.
IsConnectionsEnabled|Boolean|17|false|False|Whether connections are enabled (BooleanManagedProperty).
IsDocumentManagementEnabled|Boolean|18|false|False|Whether SharePoint document management is enabled.
IsMailMergeEnabled|Boolean|19|false|False|Whether mail merge is enabled (BooleanManagedProperty).
ChangeTrackingEnabled|Boolean|20|false|False|Whether change tracking is enabled (required by some synchronizations).
SyncToExternalSearchIndex|Boolean|21|false|False|Whether the table is indexed by Dataverse search.

## Outputs
Microsoft.Xrm.Sdk.Metadata.EntityMetadata. Only the given properties are set, so the object can serve a minimal update.

## Usage

```Powershell 
New-XrmTable [[-LogicalName] <String>] [[-DisplayName] <String>] [[-PluralName] <String>] [[-Description] <String>] [[-OwnershipType] {None | UserOwned | TeamOwned | BusinessOwned | OrganizationOwned | BusinessParented | Filtered}] [[-HasNotes] <Boolean>] [[-HasActivities] <Boolean>] [[-IsActivity] <Boolean>] [[-IsAuditEnabled] <Boolean>] [[-LanguageCode] <Int32>] [[-DisplayNameLabels] <Hashtable>] [[-PluralNameLabels] <Hashtable>] [[-DescriptionLabels] <Hashtable>] [[-IconVectorName] <String>] [[-IsAvailableOffline] <Boolean>] [[-IsQuickCreateEnabled] <Boolean>] [[-IsConnectionsEnabled] <Boolean>] [[-IsDocumentManagementEnabled] <Boolean>] [[-IsMailMergeEnabled] <Boolean>] [[-ChangeTrackingEnabled] <Boolean>] [[-SyncToExternalSearchIndex] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
# The metadata that Add-XrmTable and Set-XrmTable send
$metadata = New-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects";
``` 


```Powershell 
$metadata = New-XrmTable -LogicalName "new_project" -DisplayNameLabels @{ 1033 = "Project"; 1036 = "Projet" } -PluralNameLabels @{ 1033 = "Projects"; 1036 = "Projets" };
``` 



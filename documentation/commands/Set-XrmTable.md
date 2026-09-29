# Command : `Set-XrmTable` 

## Description

**Update a table in Microsoft Dataverse.** : Update an existing entity / table metadata using UpdateEntityRequest.
Only the given properties are sent (minimal metadata): the platform validates every property the request carries, and leaves the others as they are.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
MetadataId|Guid|2|false||The MetadataId (GUID) of the table to update. Either MetadataId or LogicalName is required.
DisplayName|String|3|false||New display name for the table.
DisplayCollectionName|String|4|false||New plural display name for the table.
Description|String|5|false||
OwnershipType|OwnershipTypes|6|false||Ownership type (UserOwned or OrganizationOwned).
IsActivity|Boolean|7|false|False|Whether the table is an activity entity.
HasNotes|Boolean|8|false|False|Whether the table has notes enabled.
HasActivities|Boolean|9|false|False|Whether the table has activities enabled.
IsAuditEnabled|Boolean|10|false|False|Whether auditing is enabled on the table.
SolutionUniqueName|String|11|false||Solution unique name context for the update.
MergeLabels|Boolean|12|false|True|Whether to merge labels. Default: true. With DisplayNameLabels, PluralNameLabels or DescriptionLabels, the current labels of the other languages are read and sent too: the platform would otherwise copy the given text into the language of the caller when it is missing.
LanguageCode|Int32|13|false|1033|Language code for labels. Default: 1033.
DisplayNameLabels|Hashtable|14|false||Hashtable of language code to display name for multilingual labels. Takes precedence over -DisplayName. Example: @{ 1033 = "Customer"; 1036 = "Client" }
PluralNameLabels|Hashtable|15|false||Hashtable of language code to plural display name for multilingual labels. Takes precedence over -DisplayCollectionName.
DescriptionLabels|Hashtable|16|false||Hashtable of language code to description for multilingual labels. Takes precedence over -Description.
IconVectorName|String|17|false||Name of the vector icon to use for the table.
LogicalName|String|18|false||Logical name of the table to update, instead of MetadataId.
IsQuickCreateEnabled|Boolean|19|false|False|Whether quick create forms are enabled.
IsConnectionsEnabled|Boolean|20|false|False|Whether connections are enabled.
IsDocumentManagementEnabled|Boolean|21|false|False|Whether SharePoint document management is enabled.
IsMailMergeEnabled|Boolean|22|false|False|Whether mail merge is enabled.
ChangeTrackingEnabled|Boolean|23|false|False|Whether change tracking is enabled.
SyncToExternalSearchIndex|Boolean|24|false|False|Whether the table is indexed by Dataverse search.
IsAvailableOffline|Boolean|25|false|False|Whether the table is available offline.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateEntity response.

## Usage

```Powershell 
Set-XrmTable [[-XrmClient] <ServiceClient>] [[-MetadataId] <Guid>] [[-DisplayName] <String>] [[-DisplayCollectionName] <String>] [[-Description] <String>] [[-OwnershipType] {None | UserOwned | TeamOwned | BusinessOwned | OrganizationOwned | BusinessParented | Filtered}] [[-IsActivity] <Boolean>] [[-HasNotes] <Boolean>] [[-HasActivities] <Boolean>] [[-IsAuditEnabled] <Boolean>] [[-SolutionUniqueName] <String>] [[-MergeLabels] <Boolean>] [[-LanguageCode] <Int32>] [[-DisplayNameLabels] <Hashtable>] [[-PluralNameLabels] <Hashtable>] [[-DescriptionLabels] <Hashtable>] [[-IconVectorName] <String>] [[-LogicalName] <String>] [[-IsQuickCreateEnabled] <Boolean>] [[-IsConnectionsEnabled] <Boolean>] [[-IsDocumentManagementEnabled] <Boolean>] [[-IsMailMergeEnabled] <Boolean>] [[-ChangeTrackingEnabled] <Boolean>] [[-SyncToExternalSearchIndex] <Boolean>] [[-IsAvailableOffline] <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmTable -MetadataId "00000000-0000-0000-0000-000000000001" -DisplayName "Customer" -DisplayCollectionName "Customers";
``` 


```Powershell 
Set-XrmTable -MetadataId $metadataId -DisplayNameLabels @{ 1033 = "Customer"; 1036 = "Client" } -PluralNameLabels @{ 1033 = "Customers"; 1036 = "Clients" };
``` 


```Powershell 
Set-XrmTable -XrmClient $xrmClient -LogicalName "new_project" -ChangeTrackingEnabled $true -IsQuickCreateEnabled $true;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmTable.md



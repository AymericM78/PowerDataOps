# Command : `Set-XrmTable` 

## Description

**Update a table in Microsoft Dataverse.** : Update an existing entity / table metadata using UpdateEntityRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
MetadataId|Guid|2|true||The MetadataId (GUID) of the table to update.
DisplayName|String|3|false||New display name for the table.
DisplayCollectionName|String|4|false||New plural display name for the table.
Description|String|5|false||
OwnershipType|OwnershipTypes|6|false||Ownership type (UserOwned or OrganizationOwned).
IsActivity|Boolean|7|false|False|Whether the table is an activity entity.
HasNotes|Boolean|8|false|False|Whether the table has notes enabled.
HasActivities|Boolean|9|false|False|Whether the table has activities enabled.
IsAuditEnabled|Boolean|10|false|False|Whether auditing is enabled on the table.
SolutionUniqueName|String|11|false||Solution unique name context for the update.
MergeLabels|Boolean|12|false|True|Whether to merge labels. Default: true.
LanguageCode|Int32|13|false|1033|Language code for labels. Default: 1033.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateEntity response.

## Usage

```Powershell 
Set-XrmTable [[-XrmClient] <ServiceClient>] [-MetadataId] <Guid> [[-DisplayName] <String>] [[-DisplayCollectionName] <String>] [[-Description] <String>] 
[[-OwnershipType] {None | UserOwned | TeamOwned | BusinessOwned | OrganizationOwned | BusinessParented | Filtered}] [[-IsActivity] <Boolean>] 
[[-HasNotes] <Boolean>] [[-HasActivities] <Boolean>] [[-IsAuditEnabled] <Boolean>] [[-SolutionUniqueName] <String>] [[-MergeLabels] <Boolean>] 
[[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmTable -MetadataId "00000000-0000-0000-0000-000000000001" -DisplayName "Customer" -DisplayCollectionName "Customers";
``` 



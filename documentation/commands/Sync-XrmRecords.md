# Command : `Sync-XrmRecords` 

## Description

**Synchronize records between two Dataverse instances.** : Reads records from a source instance, transforms attributes according to sync options,
then upserts records in a target instance. Supports optional two-pass dependency sync.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
SourceXrmClient|ServiceClient|1|true||Source Dataverse connector.
TargetXrmClient|ServiceClient|2|true||Target Dataverse connector.
LogicalNames|String[]|3|true||Entity logical names to synchronize.
Columns|String[]|4|false|@("*")|Columns to retrieve from source entities. Default: *
ExcludedAttributes|String[]|5|false|@(
            "createdon",
            "modifiedon",
            "createdby",
            "modifiedby",
            "createdonbehalfby",
            "modifiedonbehalfby",
            "ownerid",
            "owningbusinessunit",
            "owninguser",
            "owningteam",
            "statecode",
            "statuscode",
            "transactioncurrencyid"
        )|Attribute logical names excluded from synchronization.
IncludeEntityReferences|Boolean|6|false|False|Include EntityReference attributes in synchronization.
TwoPassDependencies|Boolean|7|false|False|Run sync in 2 passes. First pass excludes EntityReference attributes,
second pass includes them.
PreserveCreatedOn|Boolean|8|false|True|Preserve source createdon value using overriddencreatedon when available.
StateHandling|String|9|false|Ignore|Controls state/status handling after upsert:
- Ignore
- ApplyStateCode
- ApplyStateAndStatus
BypassCustomPluginExecution|SwitchParameter|named|false|False|Bypass custom plugin execution during upsert.
ContinueOnError|Boolean|10|false|True|Continue processing records when one record fails.
TopCount|Int32|11|false|0|Limit source record retrieval.
OrderByField|String|12|false||Optional order field applied to source query.
OrderType|OrderType|13|false|Descending|Query order direction when OrderByField is provided.

## Outputs
PSCustomObject array.

## Usage

```Powershell 
Sync-XrmRecords [-SourceXrmClient] <ServiceClient> [-TargetXrmClient] <ServiceClient> [-LogicalNames] <String[]> [[-Columns] <String[]>] 
[[-ExcludedAttributes] <String[]>] [[-IncludeEntityReferences] <Boolean>] [[-TwoPassDependencies] <Boolean>] [[-PreserveCreatedOn] <Boolean>] 
[[-StateHandling] <String>] [-BypassCustomPluginExecution] [[-ContinueOnError] <Boolean>] [[-TopCount] <Int32>] [[-OrderByField] <String>] [[-OrderType] 
{Ascending | Descending}] [<CommonParameters>]
``` 

## Examples

```Powershell 
Sync-XrmRecords -SourceXrmClient $source -TargetXrmClient $target -LogicalNames @("account") -Columns @("name");
``` 



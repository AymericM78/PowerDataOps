# Command : `Split-XrmRecords` 

## Description

**Disassociate records in Dataverse.** : Remove a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
RecordReference|EntityReference|2|true||
RecordReferences|EntityReference[]|3|true||Rows / Records references to split to Record. (EntityReference array)
RelationShipName|String|4|true||RelationShip Logical name involve between these records.
RelationShipRole|EntityRole|5|false|Referencing|


## Usage

```Powershell 
Split-XrmRecords [[-XrmClient] <CrmServiceClient>] [-RecordReference] <EntityReference> [-RecordReferences] <EntityReference[]> [-RelationShipName] <String> 
[[-RelationShipRole] {Referencing | Referenced}] [<CommonParameters>]
``` 



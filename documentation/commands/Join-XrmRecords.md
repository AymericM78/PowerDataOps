# Command : `Join-XrmRecords` 

## Description

**Associate records in Dataverse.** : Add a link between 1 row (Entity record) and multiple rows in Microsoft Dataverse.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Record|Entity|2|true||Row / Record to join. (Entity)
RecordReferences|EntityReference[]|3|true||Rows / Records references to link to Record. (EntityReference array)
RelationShipName|String|4|true||RelationShip Logical name involve between these records.
IgnoreExistings|Boolean|5|false|True|Prevent exceptions if record associations already exist (error => Cannot insert duplicate key).


## Usage

```Powershell 
Join-XrmRecords [[-XrmClient] <CrmServiceClient>] [-Record] <Entity> [-RecordReferences] <EntityReference[]> [-RelationShipName] <String> [[-IgnoreExistings] 
<Boolean>] [<CommonParameters>]
``` 



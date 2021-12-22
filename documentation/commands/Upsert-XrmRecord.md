# Command : `Upsert-XrmRecord` 

## Description

**Upsert entity record in Dataverse.** : Upsert row (entity record) from Microsoft Dataverse table.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Record|Entity|2|true||Record (row) to Upsert.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Specify wether involved plugins should be triggered or not during this operation. (Default: False)

## Outputs
System.Guid

## Usage

```Powershell 
Upsert-XrmRecord [[-XrmClient] <CrmServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] 
[<CommonParameters>]
``` 



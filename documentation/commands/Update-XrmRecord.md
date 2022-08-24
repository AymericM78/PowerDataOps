# Command : `Update-XrmRecord` 

## Description

**Update entity record in Microsoft Dataverse.** : Update row (entity record) from Microsoft Dataverse table.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Record|Entity|2|true||Record (row) to update.
BypassCustomPluginExecution|SwitchParameter|named|false|False|Specify wether involved plugins should be triggered or not during this operation. (Default: False)


## Usage

```Powershell 
Update-XrmRecord [[-XrmClient] <CrmServiceClient>] [-Record] <Entity> [-BypassCustomPluginExecution] [<CommonParameters>]
``` 



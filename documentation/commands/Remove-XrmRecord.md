# Command : `Remove-XrmRecord` 

## Description

**Remove record from Microsoft Dataverse.** : Delete row (entity record) from Microsoft Dataverse table by logicalname + id or by Entity object.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Record|Entity|2|false||Record (row) to delete.
LogicalName|String|3|false||Table / Entity logical name..
Id|Guid|4|false||Row (entity record) unique identifier
BypassCustomPluginExecution|SwitchParameter|named|false|False|Specify wether involved plugins should be triggered or not during this operation. (Default: False)


## Usage

```Powershell 
Remove-XrmRecord [[-XrmClient] <ServiceClient>] [[-Record] <Entity>] [[-LogicalName] <String>] [[-Id] <Guid>] [-BypassCustomPluginExecution] [<CommonParameters>]
``` 



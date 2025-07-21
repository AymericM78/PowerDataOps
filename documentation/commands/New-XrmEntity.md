# Command : `New-XrmEntity` 

## Description

**Initialize Entity object instance.** : Create a new Microsoft Dataverse Entity object.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Table / Entity logical name.
Id|Guid|2|false||Record unique identifier.
Attributes|Hashtable|3|false||Attributes array (Key value pair: logicalname = value).

## Outputs
Microsoft.Xrm.Sdk.Entity

## Usage

```Powershell 
New-XrmEntity [-LogicalName] <String> [[-Id] <Guid>] [[-Attributes] <Hashtable>] [<CommonParameters>]
``` 



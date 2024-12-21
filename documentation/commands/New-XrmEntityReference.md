# Command : `New-XrmEntityReference` 

## Description

**Initialize EntityReference object instance.** : Get new EntityReference object from lookup information.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
LogicalName|String|1|true||Table / Entity logical name.
Key|String|2|false||Lookup to alternate key name.
Value|Object|3|true||Key value.

## Outputs
Microsoft.Xrm.Sdk.EntityReference

## Usage

```Powershell 
New-XrmEntityReference [-LogicalName] <String> [[-Key] <String>] [-Value] <Object> [<CommonParameters>]
``` 



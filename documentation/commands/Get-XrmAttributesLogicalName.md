# Command : `Get-XrmAttributesLogicalName` 

## Description

**Retrieve entities logicalname attribute.** : Get list of columns / attribute logical names from given entity / table.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.


## Usage

```Powershell 
Get-XrmAttributesLogicalName [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [<CommonParameters>]
``` 



# Command : `Get-XrmAttributesLogicalName` 

## Description

**Retrieve entities logicalname attribute.** : Get list of columns / attribute logical names from given entity / table.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.

## Outputs

## Usage

```Powershell 
Get-XrmAttributesLogicalName [[-XrmClient] <CrmServiceClient>] [-EntityLogicalName] <String> [<CommonParameters>]
``` 



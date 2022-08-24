# Command : `Invoke-XrmSqlCommand` 

## Description

**Connect to TDS endpoint.** : Specify connection parameters to run SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|
Command|String|2|true||SQL Statement
IgnoreDbNull|SwitchParameter|named|false|False|


## Usage

```Powershell 
Invoke-XrmSqlCommand [[-XrmClient] <CrmServiceClient>] [-Command] <String> [-IgnoreDbNull] [<CommonParameters>]
``` 



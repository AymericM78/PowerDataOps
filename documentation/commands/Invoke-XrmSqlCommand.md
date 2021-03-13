# Command : `Invoke-XrmSqlCommand` 

## Description

**Connect to TDS endpoint.** : Specify connection parameters to run SQL commands thru TDS Endpoint.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Command|String|1|true||SQL Statement
IgnoreDbNull|SwitchParameter|named|false|False|


## Usage

```Powershell 
Invoke-XrmSqlCommand [-Command] <String> [-IgnoreDbNull] [<CommonParameters>]
``` 



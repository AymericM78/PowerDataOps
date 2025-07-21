# Command : `Out-XrmConnectionStringParameter` 

## Description

**Extract parameter value from connectionstring.** : Output connection string parameter value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|true||Connection string.
ParameterName|String|2|true||Parameter name.
RaiseErrorIfMising|SwitchParameter|named|false|False|If parameter is not found, throw an exception.


## Usage

```Powershell 
Out-XrmConnectionStringParameter [-ConnectionString] <String> [-ParameterName] <String> [-RaiseErrorIfMising] 
[<CommonParameters>]
``` 



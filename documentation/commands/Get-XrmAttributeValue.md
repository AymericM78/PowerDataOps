# Command : `Get-XrmAttributeValue` 

## Description

**Read entity attribute.** : Extract entity attribute value from record / table row.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Record|Entity|1|true||Entity record / table row (Entity).
Name|String|2|true||Attribute (Column) name.
FormattedValue|SwitchParameter|named|false|False|Specify if expected value should be provided from FormattedValues <> raw value.
RaiseErrorIfMissing|Boolean|3|false|False|If true, throws an exception if attribute/column is not present in row / record. Else, ignore.


## Usage

```Powershell 
Get-XrmAttributeValue [-Record] <Entity> [-Name] <String> [-FormattedValue] [[-RaiseErrorIfMissing] <Boolean>] [<CommonParameters>]
``` 



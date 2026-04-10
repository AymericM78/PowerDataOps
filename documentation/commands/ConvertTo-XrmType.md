# Command : `ConvertTo-XrmType` 

## Description

**Convert a value to the appropriate Dataverse SDK type.** : Transform a raw value (string, number) to a typed Dataverse attribute value based on the specified type
(int, decimal, datetime, money, bool, guid, optionset, optionsetvalues, entityreference, string).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Type|String|1|true||Target Dataverse attribute type name.
Value|Object|2|true||Raw value to convert.
EntityLogicalName|String|3|false||Logical name of the target entity (required for entityreference type).


## Usage

```Powershell 
ConvertTo-XrmType [-Type] <String> [-Value] <Object> [[-EntityLogicalName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$moneyValue = ConvertTo-XrmType -Type "money" -Value "150.50";
``` 


```Powershell 
$optionSet = ConvertTo-XrmType -Type "optionset" -Value 1;
``` 


```Powershell 
$ref = ConvertTo-XrmType -Type "entityreference" -Value $guid -EntityLogicalName "account";
``` 



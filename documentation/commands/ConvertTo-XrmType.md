# Command : `ConvertTo-XrmType` 

## Description

**Convert a value to the appropriate Dataverse SDK type.** : Transform a raw value (string, number) to a typed Dataverse attribute value based on the specified type
(int, decimal, datetime, money, bool, guid, optionset, optionsetvalues, entityreference, string).
Strings are parsed with the current culture unless Culture is given; values that are already numbers or dates are cast, not parsed.
A bool is read from a bool, a number (0 = false) or a string matched against TrueValues / FalseValues; any other string raises an error.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Type|String|1|true||Target Dataverse attribute type name.
Value|Object|2|true||Raw value to convert.
EntityLogicalName|String|3|false||Logical name of the target entity (required for entityreference type).
Culture|CultureInfo|4|false|[System.Globalization.CultureInfo]::CurrentCulture|Culture used to parse int, decimal, money and datetime strings, e.g. "fr-FR" or [cultureinfo]::InvariantCulture. (Default: current culture)
Format|String|5|false||Exact format of a datetime string (e.g. "dd/MM/yyyy"), parsed with DateTime.ParseExact. (Default: none, DateTime.Parse is used)
TrueValues|String[]|6|false|@("true", "1", "yes")|Strings read as true for the bool type, case-insensitive. (Default: "true", "1", "yes")
FalseValues|String[]|7|false|@("false", "0", "no")|Strings read as false for the bool type, case-insensitive. An empty string is always false. (Default: "false", "0", "no")

## Outputs
System.Object. The typed value (int, decimal, DateTime, Money, bool, Guid, OptionSetValue, OptionSetValueCollection, EntityReference or string).

## Usage

```Powershell 
ConvertTo-XrmType [-Type] <String> [-Value] <Object> [[-EntityLogicalName] <String>] [[-Culture] <CultureInfo>] [[-Format] <String>] [[-TrueValues] <String[]>] [[-FalseValues] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$moneyValue = ConvertTo-XrmType -Type "money" -Value "150.50" -Culture ([cultureinfo]::InvariantCulture);
``` 


```Powershell 
$optionSet = ConvertTo-XrmType -Type "optionset" -Value 1;
``` 


```Powershell 
$ref = ConvertTo-XrmType -Type "entityreference" -Value $guid -EntityLogicalName "account";
``` 


```Powershell 
$date = ConvertTo-XrmType -Type "datetime" -Value "31/12/2026" -Format "dd/MM/yyyy";
``` 


```Powershell 
$flag = ConvertTo-XrmType -Type "bool" -Value "Oui" -TrueValues "oui" -FalseValues "non";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertTo-XrmType.md



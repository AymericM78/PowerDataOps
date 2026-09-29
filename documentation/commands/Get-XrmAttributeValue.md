# Command : `Get-XrmAttributeValue` 

## Description

**Read entity attribute.** : Extract entity attribute value from record / table row.
The record can be an Entity or a row returned by Get-XrmRecord / Get-XrmMultipleRecords (its Record property is read, so the value is the typed one, not the display label).
A missing column, or a $null record, gives $null.
Alias: Get-XrmRowValue. The alias always runs this command, even in a script that defines its own Get-XrmRowValue or Get-XrmAttributeValue function (PowerShell resolves an alias before a function).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Record|Object|1|true||Entity record / table row (Entity), or a row converted by the module (custom object with a Record property). $null is accepted. Alias: Row.
Name|String|2|true||Attribute (Column) name. Alias: Column.
FormattedValue|SwitchParameter|named|false|False|Specify if expected value should be provided from FormattedValues <> raw value.
RaiseErrorIfMissing|Boolean|3|false|False|If true, throws an exception if attribute/column is not present in row / record. Else, ignore.
Raw|SwitchParameter|named|false|False|Return a plain .NET value: OptionSetValue => int, OptionSetValueCollection => int[], Money => decimal, AliasedValue => inner value, BooleanManagedProperty => bool. Lookups stay EntityReference (see AsId).
AsId|SwitchParameter|named|false|False|Return the Guid of a lookup (EntityReference) column, $null when empty.

## Outputs
System.Object. The column value.

## Usage

```Powershell 
Get-XrmAttributeValue [-Record] <Object> [-Name] <String> [-FormattedValue] [[-RaiseErrorIfMissing] <Boolean>] [-Raw] [-AsId] [<CommonParameters>]
``` 

## Examples

```Powershell 
$name = Get-XrmAttributeValue -Record $entity -Name "name";
``` 


```Powershell 
$account = Get-XrmRecord -LogicalName "account" -Id $accountId -Columns "industrycode", "donotemail", "parentaccountid";
$industryCode = $account | Get-XrmRowValue -Name "industrycode" -Raw;     # int, not the label
$doNotEmail = $account | Get-XrmRowValue -Name "donotemail";               # bool, not "Do Not Allow"
$parentId = $account | Get-XrmRowValue -Name "parentaccountid" -AsId;      # Guid or $null
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAttributeValue.md



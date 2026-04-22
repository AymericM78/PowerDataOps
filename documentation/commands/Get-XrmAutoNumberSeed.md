# Command : `Get-XrmAutoNumberSeed` 

## Description

**Get the current auto-number seed for a column.** : Retrieve the current auto-number seed value for an auto-number column using the GetAutoNumberSeed SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the entity containing the auto-number column.
AttributeLogicalName|String|3|true||Logical name of the auto-number column.

## Outputs
System.Int64. The current seed value.

## Usage

```Powershell 
Get-XrmAutoNumberSeed [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-AttributeLogicalName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$seed = Get-XrmAutoNumberSeed -EntityLogicalName "new_invoice" -AttributeLogicalName "new_invoicenumber";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/create-auto-number-attributes



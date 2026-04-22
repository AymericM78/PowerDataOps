# Command : `Set-XrmAutoNumberSeed` 

## Description

**Set the auto-number seed for a column.** : Set the next auto-number value for an auto-number column using the SetAutoNumberSeed SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the entity containing the auto-number column.
AttributeLogicalName|String|3|true||Logical name of the auto-number column.
Value|Int64|4|true|0|The new seed value (next number to be assigned).

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The SetAutoNumberSeed response.

## Usage

```Powershell 
Set-XrmAutoNumberSeed [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-AttributeLogicalName] <String> [-Value] <Int64> [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmAutoNumberSeed -EntityLogicalName "new_invoice" -AttributeLogicalName "new_invoicenumber" -Value 10000;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/create-auto-number-attributes



# Command : `New-XrmMoney` 

## Description

**Initialize Money object instance.** : Get new money object from given decimal value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Value|Decimal|1|true|0|Decimal value.

## Outputs
Microsoft.Xrm.Sdk.Money. The initialized Money object.

## Usage

```Powershell 
New-XrmMoney [-Value] <Decimal> [<CommonParameters>]
``` 

## Examples

```Powershell 
$money = New-XrmMoney -Value 100.50;
``` 



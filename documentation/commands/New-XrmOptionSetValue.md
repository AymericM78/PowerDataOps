# Command : `New-XrmOptionSetValue` 

## Description

**Initialize OptionSetValue object instance.** : Get new OptionSetValue object from given int value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Value|Int32|1|true|0|Option integer value.

## Outputs
Microsoft.Xrm.Sdk.OptionSetValue. The initialized OptionSetValue object.

## Usage

```Powershell 
New-XrmOptionSetValue [-Value] <Int32> [<CommonParameters>]
``` 

## Examples

```Powershell 
$optionSet = New-XrmOptionSetValue -Value 1;
``` 



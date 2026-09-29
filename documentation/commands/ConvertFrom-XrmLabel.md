# Command : `ConvertFrom-XrmLabel` 

## Description

**Convert a Label to a hashtable of texts by language code.** : Turn a Microsoft.Xrm.Sdk.Label (metadata display names, descriptions, option labels...) into @{ languageCode = text }: the reverse of New-XrmLabel -Labels.
A $null label gives an empty hashtable.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Label|Label|1|true||Label to convert.
LanguageCodes|Int32[]|2|false||Language codes to keep. (Default: every language of the label)

## Outputs
System.Collections.Hashtable. Text by language code (int keys).

## Usage

```Powershell 
ConvertFrom-XrmLabel [-Label] <Label> [[-LanguageCodes] <Int32[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$table = Get-XrmEntityMetadata -XrmClient $xrmClient -LogicalName "account" -Filter Entity;
$names = ConvertFrom-XrmLabel -Label $table.DisplayName;   # @{ 1033 = "Account"; 1036 = "Compte" }
``` 


```Powershell 
# Copy the display names of one column to another
$labels = ConvertFrom-XrmLabel -Label $sourceColumn.DisplayName -LanguageCodes 1033, 1036;
Set-XrmColumn -XrmClient $xrmClient -EntityLogicalName "account" -Attribute $targetColumn -DisplayNameLabels $labels;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertFrom-XrmLabel.md



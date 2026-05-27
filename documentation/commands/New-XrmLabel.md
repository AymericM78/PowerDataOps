# Command : `New-XrmLabel` 

## Description

**Create a Label object for Dataverse metadata.** : Build a Microsoft.Xrm.Sdk.Label from a single text value and language code, or from a
hashtable of language code to text for multilingual labels.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Text|String|named|true||The label text (single language).
LanguageCode|Int32|named|false|1033|Language code for the label. Default: 1033 (English).
Labels|Hashtable|named|true||Hashtable of language code to label text for multilingual labels. Example: @{ 1033 = "Account"; 1036 = "Compte" }

## Outputs
Microsoft.Xrm.Sdk.Label. The label object.

## Usage

```Powershell 
New-XrmLabel -Text <String> [-LanguageCode <Int32>] [<CommonParameters>]

New-XrmLabel -Labels <Hashtable> [<CommonParameters>]
``` 

## Examples

```Powershell 
$label = New-XrmLabel -Text "Account" -LanguageCode 1033;
``` 


```Powershell 
$label = New-XrmLabel -Labels @{ 1033 = "Account"; 1036 = "Compte" };
``` 



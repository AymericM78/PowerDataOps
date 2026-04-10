# Command : `New-XrmLabel` 

## Description

**Create a Label object for Dataverse metadata.** : Build a Microsoft.Xrm.Sdk.Label from a text value and language code.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Text|String|1|true||The label text.
LanguageCode|Int32|2|false|1033|Language code for the label. Default: 1033 (English).

## Outputs
Microsoft.Xrm.Sdk.Label. The label object.

## Usage

```Powershell 
New-XrmLabel [-Text] <String> [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$label = New-XrmLabel -Text "Account" -LanguageCode 1033;
``` 



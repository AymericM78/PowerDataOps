# Command : `Get-XrmLabelText` 

## Description

**Resolve a single label text from a multilingual labels hashtable.** : Pick the label text for a given language code from a hashtable of language code to text.
If the requested language is not present, falls back to the lowest language code available.
Used by component cmdlets (forms, views, charts, dashboards, commands, app modules, sitemaps)
that store a single 'name' attribute but accept a multilingual -Labels hashtable for a
consistent authoring experience.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Labels|Hashtable|1|true||Hashtable of language code to label text. Example: @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" }
LanguageCode|Int32|2|false|1033|Preferred language code to resolve. Default: 1033 (English).

## Outputs
[String]. The resolved label text.

## Usage

```Powershell 
Get-XrmLabelText [-Labels] <Hashtable> [[-LanguageCode] <Int32>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$name = Get-XrmLabelText -Labels @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" } -LanguageCode 1036;
# returns "Comptes actifs"
``` 


```Powershell 
$name = Get-XrmLabelText -Labels @{ 1036 = "Comptes actifs" } -LanguageCode 1033;
# 1033 missing -> falls back to "Comptes actifs"
``` 



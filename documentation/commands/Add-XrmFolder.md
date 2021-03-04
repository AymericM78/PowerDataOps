# Command : `Add-XrmFolder` 

## Description

**Add folder in given path if it doesn't exists.** : Create given folder if not exist and return sub folder full path.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Path|String|1|true||Folder path where to add given folder.
FolderName|String|2|true||Folder name.
CleanIfExists|SwitchParameter|named|false|False|If folder already exists, remove existing content. (Default : False)

## Outputs

## Usage

```Powershell 
Add-XrmFolder [-Path] <String> [-FolderName] <String> [-CleanIfExists] [<CommonParameters>]
``` 



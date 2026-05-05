# Command : `Initialize-XrmPath` 

## Description

**Initialize a local file system path.** : Create a directory path if it does not exist, or create the parent directory of a file path.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Path|String|1|true||Directory path or file path to initialize.
AsFilePath|SwitchParameter|named|false|False|Treat the provided path as a file path and initialize only its parent directory.

## Outputs
System.String. The initialized path.

## Usage

```Powershell 
Initialize-XrmPath [-Path] <String> [-AsFilePath] [<CommonParameters>]
``` 

## Examples

```Powershell 
Initialize-XrmPath -Path "C:\Temp\Exports";
``` 


```Powershell 
Initialize-XrmPath -Path "C:\Temp\Exports\Accounts.xlsx" -AsFilePath;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



# Command : `Get-XrmConnection` 

## Description

**Get connections from XrmToolBox.** : Browse and retrieve information from XrmToolBox saved connections.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ListAvailable|SwitchParameter|named|false|False|Specify if you want to see all connections or all instances.
XtbConnectionPath|String|1|false|[System.IO.Path]::Combine((Get-XrmAppDataPathInternal), "MscrmTools", "XrmToolBox", "Connections")|XTB connections folder path. (Default: MscrmTools\XrmToolBox\Connections in APPDATA)


## Usage

```Powershell 
Get-XrmConnection [-ListAvailable] [[-XtbConnectionPath] <String>] [<CommonParameters>]
``` 



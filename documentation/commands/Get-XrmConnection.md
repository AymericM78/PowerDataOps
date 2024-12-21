# Command : `Get-XrmConnection` 

## Description

**Get connections from XrmToolBox.** : Browse and retrieve information from XrmToolBox saved connections.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ListAvailable|SwitchParameter|named|false|False|Specify if you want to see all connections or all instances.
XtbConnectionPath|String|1|false|"$env:APPDATA\MscrmTools\XrmToolBox\Connections"|XTB connections folder path. (Default: $env:APPDATA\MscrmTools\XrmToolBox\Connections)


## Usage

```Powershell 
Get-XrmConnection [-ListAvailable] [[-XtbConnectionPath] <String>] [<CommonParameters>]
``` 



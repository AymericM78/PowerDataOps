# Command : `Export-XrmConnectionToXrmToolBox` 

## Description

**Export instances collection to XML file with connection strings to XrmToolBox connection file.** : Populate XrmToolbox connections with available instance for given user.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmConnection|Object|1|false|$Global:XrmContext.CurrentConnection|
Name|String|2|true||XTB connection name.
OverrideConnectionStringFormat|String|3|false||Provide the ConnectionString template in order to access to instances with different credentials.
XtbConnectionPath|String|4|false|"$env:APPDATA\MscrmTools\XrmToolBox\Connections"|XTB connections folder path. (Default: $env:APPDATA\MscrmTools\XrmToolBox\Connections)


## Usage

```Powershell 
Export-XrmConnectionToXrmToolBox [[-XrmConnection] <Object>] [-Name] <String> [[-OverrideConnectionStringFormat] <String>] [[-XtbConnectionPath] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
Connect-XrmUser -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
Export-XrmConnectionToXrmToolBox -Name "Contoso"
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/samples/XrmToolBox%20Connection%20Provisionning.md



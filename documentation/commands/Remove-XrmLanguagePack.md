# Command : `Remove-XrmLanguagePack` 

## Description

**Desactivate given language** : Uninstall specify language pack from target instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Language|Int32|2|true|0|Language name LCID (English = 1033, French = 1036, ...)


## Usage

```Powershell 
Remove-XrmLanguagePack [[-XrmClient] <CrmServiceClient>] [-Language] <Int32> [<CommonParameters>]
``` 



# Command : `Publish-XrmTheme` 

## Description

**Publish theme.** : Apply theme to target instance

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Name|String|2|true||


## Usage

```Powershell 
Publish-XrmTheme [[-XrmClient] <CrmServiceClient>] [-Name] <String> [<CommonParameters>]
``` 



# Command : `Set-XrmOrganizationDbSetting` 

## Description

**Set Organization setting.** : Add or update orgdbsetting value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Name|String|2|true||Setting name to define.
Value|String|3|true||Setting value to define.


## Usage

```Powershell 
Set-XrmOrganizationDbSetting [[-XrmClient] <CrmServiceClient>] [-Name] <String> [-Value] <String> [<CommonParameters>]
``` 



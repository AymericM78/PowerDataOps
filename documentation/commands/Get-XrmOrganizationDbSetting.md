# Command : `Get-XrmOrganizationDbSetting` 

## Description

**Get Organization setting.** : Retrieve organization setting (orgdbsetting) from target instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|false||Setting name to retrieve.


## Usage

```Powershell 
Get-XrmOrganizationDbSetting [[-XrmClient] <ServiceClient>] [[-Name] <String>] [<CommonParameters>]
``` 



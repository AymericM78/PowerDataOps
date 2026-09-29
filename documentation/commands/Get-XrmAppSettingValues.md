# Command : `Get-XrmAppSettingValues` 

## Description

**Retrieve the settings values of a model-driven app.** : Read the app-level setting values (appsetting) of an app, published or not: the reading counterpart of Set-XrmAppSettingValue.
A value saved with Set-XrmAppSettingValue stays in the unpublished layer until the app is published: both layers are read, the unpublished value wins.
Returns one object per value set on the app: SettingName (setting definition unique name), Value, DefaultValue, AppSettingId.
Settings without an app value are not returned: their effective value is the organization value or the default one.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppUniqueName|String|2|true||Unique name of the app (appmodule).
SettingName|String[]|3|false||Setting definition unique names to keep. (Default: all)

## Outputs
PSCustomObject[]. SettingName, Value, DefaultValue, AppSettingId.

## Usage

```Powershell 
Get-XrmAppSettingValues [[-XrmClient] <ServiceClient>] [-AppUniqueName] <String> [[-SettingName] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Get-XrmAppSettingValues -XrmClient $xrmClient -AppUniqueName "contoso_sales" | Format-Table SettingName, Value, DefaultValue;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmAppSettingValues.md



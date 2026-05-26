# Command : `Set-XrmAppSettingValue` 

## Description

**Set model-driven app setting value.** : Set a named setting for a specific model-driven app by calling Set-XrmSettingValue with the app scope.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppUniqueName|String|2|true||Unique name of the model-driven app (mandatory).
SettingName|String|3|true||Unique name of the setting to set (e.g. "OverrideAppHeaderColor").
Value|String|4|true||Value to assign to the setting.
SolutionUniqueName|String|5|false||Unique name of the solution to associate the change with. Optional.

## Outputs
[System.Void]

## Usage

```Powershell 
Set-XrmAppSettingValue [[-XrmClient] <ServiceClient>] [-AppUniqueName] <String> [-SettingName] <String> [-Value] <String> [[-SolutionUniqueName] 
<String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$xrmClient | Set-XrmAppSettingValue -AppUniqueName "msdyn_FieldService" -SettingName "OverrideAppHeaderColor" -Value "#FF0000";
``` 


```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$xrmClient | Set-XrmAppSettingValue -AppUniqueName "msdyn_FieldService" -SettingName "OverrideAppHeaderColor" -Value "#FF0000" -SolutionUniqueName "MySolution";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAppSettingValue.md



# Command : `Set-XrmAppSettingValue` 

## Description

**Set model-driven app setting value.** : Set a named setting for a specific model-driven app by calling Set-XrmSettingValue with the app scope.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AppUniqueName|String|2|true||Unique name of the model-driven app.
SettingName|String|3|true||Unique name of the setting to set (e.g. "OverrideAppHeaderColor").
Value|String|4|true||Value to assign to the setting.
SolutionUniqueName|String|5|false||Unique name of the solution to associate the change with. Optional.


## Usage

```Powershell 
Set-XrmAppSettingValue [[-XrmClient] <ServiceClient>] [-AppUniqueName] <String> [-SettingName] <String> [-Value] <String> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell
# Set a header color override on a specific app
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$xrmClient | Set-XrmAppSettingValue -AppUniqueName "msdyn_FieldService" -SettingName "OverrideAppHeaderColor" -Value "#FF0000";
```

```Powershell
# Set a setting and associate it with a solution
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$xrmClient | Set-XrmAppSettingValue -AppUniqueName "msdyn_FieldService" -SettingName "OverrideAppHeaderColor" -Value "#FF0000" -SolutionUniqueName "MySolution";
```


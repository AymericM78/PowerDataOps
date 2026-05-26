# Command : `Set-XrmSettingValue` 

## Description

**Set environment or app setting value.** : Call the SaveSettingValue SDK action to create or update a named setting at environment or app level.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SettingName|String|2|true||Unique name of the setting to set (e.g. "OverrideAppHeaderColor").
Value|String|3|true||Value to assign to the setting.
AppUniqueName|String|4|false||Unique name of the model-driven app this setting applies to. Omit for environment-level setting.
SolutionUniqueName|String|5|false||Unique name of the solution to associate the change with. Optional.

## Outputs
[System.Void]

## Usage

```Powershell 
Set-XrmSettingValue [[-XrmClient] <ServiceClient>] [-SettingName] <String> [-Value] <String> [[-AppUniqueName] <String>] [[-SolutionUniqueName] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$xrmClient | Set-XrmSettingValue -SettingName "OverrideAppHeaderColor" -Value "#FF0000";
``` 


```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$xrmClient | Set-XrmSettingValue -SettingName "OverrideAppHeaderColor" -Value "#FF0000" -AppUniqueName "msdyn_FieldService" -SolutionUniqueName "MySolution";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmSettingValue.md



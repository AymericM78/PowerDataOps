# Command : `Get-XrmEnvironmentVariable` 

## Description

**Retrieve an environment variable: definition, value and effective value.** : Read an environment variable definition and its value record (override) in one query, and return a summary:
SchemaName, DisplayName, Type (String, Number, Boolean, JSON, DataSource, Secret), DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.
EffectiveValue is the override when a value record exists (even empty), else the default value.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Environment variable definition schema name.
IfExists|SwitchParameter|named|false|False|Return $null when the definition does not exist, instead of raising an error.

## Outputs
PSCustomObject. SchemaName, DisplayName, Type, DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.

## Usage

```Powershell 
Get-XrmEnvironmentVariable [[-XrmClient] <ServiceClient>] [-Name] <String> [-IfExists] [<CommonParameters>]
``` 

## Examples

```Powershell 
$variable = Get-XrmEnvironmentVariable -XrmClient $xrmClient -Name "new_ApiUrl";
if ($variable.HasOverride) { Write-Host "Overridden: $($variable.Value)"; }
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariable.md



# Command : `Get-XrmEnvironmentVariableDefinitions` 

## Description

**List the environment variables of the organization.** : Return one summary per environment variable definition (see Get-XrmEnvironmentVariable): SchemaName, DisplayName, Type, DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Type|String[]|2|false||Types to keep: String, Number, Boolean, JSON, DataSource, Secret. (Default: all)
Prefix|String|3|false||Keep only the schema names starting with this prefix (e.g. a publisher prefix "new_"). (Default: all)

## Outputs
PSCustomObject. One summary per environment variable.

## Usage

```Powershell 
Get-XrmEnvironmentVariableDefinitions [[-XrmClient] <ServiceClient>] [[-Type] <String[]>] [[-Prefix] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Get-XrmEnvironmentVariableDefinitions -XrmClient $xrmClient -Prefix "new_" | Format-Table SchemaName, EffectiveValue, HasOverride;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariableDefinitions.md



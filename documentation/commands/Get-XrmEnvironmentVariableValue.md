# Command : `Get-XrmEnvironmentVariableValue` 

## Description

**Retrieve environment variable value.** : Get the current value of a Dataverse environment variable by its schema name.
When a value record (override) exists, its value is returned, even when it is empty; otherwise the definition default value is returned.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Environment variable definition schema name.
IfExists|SwitchParameter|named|false|False|Return $null when the definition does not exist, instead of raising an error.

## Outputs
String. Current environment variable value or default value if no current value is set.

## Usage

```Powershell 
Get-XrmEnvironmentVariableValue [[-XrmClient] <ServiceClient>] [-Name] <String> [-IfExists] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$value = Get-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_SynchTrackingFunctionUrl";
``` 


```Powershell 
$value = Get-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_OptionalSetting" -IfExists;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmEnvironmentVariableValue.md



# Command : `Get-XrmEnvironmentVariableValue` 

## Description

**Retrieve environment variable value.** : Get the current value of a Dataverse environment variable by its schema name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Environment variable definition schema name.

## Outputs
String. Current environment variable value or default value if no current value is set.

## Usage

```Powershell 
Get-XrmEnvironmentVariableValue [[-XrmClient] <ServiceClient>] [-Name] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$value = Get-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_SynchTrackingFunctionUrl";
``` 



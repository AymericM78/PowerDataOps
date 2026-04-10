# Command : `Set-XrmEnvironmentVariableValue` 

## Description

**Set environment variable value.** : Create or update the current value of a Dataverse environment variable by its schema name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Environment variable definition schema name.
Value|String|3|true||Value to set for the environment variable.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Entity reference of the created or updated environment variable value record.

## Usage

```Powershell 
Set-XrmEnvironmentVariableValue [[-XrmClient] <ServiceClient>] [-Name] <String> [-Value] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
Set-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "df_SynchTrackingFunctionUrl" -Value "https://myfunc.azurewebsites.net/api/execute";
``` 



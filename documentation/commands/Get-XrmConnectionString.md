# Command : `Get-XrmConnectionString` 

## Description

**Read a connection string from a .NET configuration file.** : Read the connectionString of an <add name="..."> entry under <connectionStrings>, in a standard .NET configuration file:
a connectionStrings.config file (<connectionStrings> root) or an app.config / web.config file (<configuration><connectionStrings>).
The name is compared without case. Raises an error when the file or the entry does not exist.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConfigPath|String|1|true||Path of the configuration file.
Name|String|2|true||Name of the connection string entry.

## Outputs
System.String. The connection string.

## Usage

```Powershell 
Get-XrmConnectionString [-ConfigPath] <String> [-Name] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$connectionString = Get-XrmConnectionString -ConfigPath ".\connectionStrings.config" -Name "Dev";
$xrmClient = New-XrmClient -ConnectionString $connectionString;
``` 


```Powershell 
# Show the host of the target environment
Get-XrmConnectionString -ConfigPath ".\connectionStrings.config" -Name "Dev" | Out-XrmConnectionStringParameter -ParameterName "Url";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmConnectionString.md



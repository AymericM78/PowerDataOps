# Command : `New-XrmClient` 

## Description

**Initialize CrmServiceClient instance.** : Create a new connection to Microsoft Dataverse with a connectionstring.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false||Connection String to Microsoft Dataverse instance (https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect)
MaxCrmConnectionTimeOutMinutes|Int32|2|false|2|Specify timeout duration in minutes.
IsEncrypted|Boolean|3|false|False|Specify if password or secret are encrypted.
Quiet|SwitchParameter|named|false|False|Do not display the connection message.
ConfigPath|String|4|false||Configuration file holding the connection string, in the standard .NET format (connectionStrings.config, app.config...), with ConnectionName, instead of ConnectionString. See Get-XrmConnectionString.
ConnectionName|String|5|false||Name of the connection string entry in ConfigPath.

## Outputs
Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

## Usage

```Powershell 
New-XrmClient [[-ConnectionString] <String>] [[-MaxCrmConnectionTimeOutMinutes] <Int32>] [[-IsEncrypted] <Boolean>] [-Quiet] [[-ConfigPath] <String>] [[-ConnectionName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
``` 


```Powershell 
$xrmClient = New-XrmClient -ConfigPath ".\connectionStrings.config" -ConnectionName "Dev";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



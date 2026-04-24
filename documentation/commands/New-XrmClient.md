# Command : `New-XrmClient` 

## Description

**Initialize CrmServiceClient instance.** : Create a new connection to Microsoft Dataverse with a connection string. If the connection string only contains `Url`, the cmdlet applies interactive OAuth defaults (`AuthType=OAuth`, sample `AppId`, `RedirectUri=http://localhost`, `LoginPrompt=Auto`).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false||Connection string to Microsoft Dataverse. At minimum it must contain `Url=<DataverseUrl>`. See https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect
MaxCrmConnectionTimeOutMinutes|Int32|2|false|2|Specify timeout duration in minutes.
IsEncrypted|Boolean|3|false|False|Specify if password or secret are encrypted.
Quiet|SwitchParameter|named|false|False|

## Outputs
Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

## Usage

```Powershell 
New-XrmClient [[-ConnectionString] <String>] [[-MaxCrmConnectionTimeOutMinutes] <Int32>] [[-IsEncrypted] <Boolean>] [-Quiet] [<CommonParameters>]
``` 

## Examples

```Powershell 
New-XrmClient -ConnectionString "Url=https://contoso.crm.dynamics.com";

$xrmClient = New-XrmClient -ConnectionString $connectionString;

New-XrmClient -ConnectionString "AuthType=ClientSecret;Url=https://contoso.crm.dynamics.com;ClientId=<app-id>;ClientSecret=<secret>";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



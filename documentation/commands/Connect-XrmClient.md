# Command : `Connect-XrmClient` 

## Description

**Connect to Microsoft Dataverse without manually composing a connection string.** : Build a Dataverse connection string from explicit authentication parameters or from a URL-only interactive login scenario, then delegate the connection to New-XrmClient.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Url|String|named|true||Dataverse environment URL.
UserName|String|named|false||User login for OAuth username/password authentication or interactive login hint.
Password|String|named|true||User password for OAuth username/password authentication.
ClientId|String|named|false||Application or client ID.
ClientSecret|String|named|true||Application client secret.
CertificateThumbprint|String|named|true||Application certificate thumbprint.
RedirectUri|String|named|false||OAuth redirect URI.
LoginPrompt|String|named|false||OAuth login prompt behavior.
IsEncrypted|Boolean|named|false|False|Specify if password or secret are encrypted.
Quiet|SwitchParameter|named|false|False|

## Outputs
Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

## Usage

```Powershell 
Connect-XrmClient -Url <String> [-UserName <String>] [-ClientId <String>] [-RedirectUri <String>] [-LoginPrompt <String>] [-IsEncrypted <Boolean>] 
[-Quiet] [<CommonParameters>]

Connect-XrmClient -Url <String> -ClientId <String> -CertificateThumbprint <String> [-IsEncrypted <Boolean>] [-Quiet] [<CommonParameters>]

Connect-XrmClient -Url <String> -ClientId <String> -ClientSecret <String> [-IsEncrypted <Boolean>] [-Quiet] [<CommonParameters>]

Connect-XrmClient -Url <String> -UserName <String> -Password <String> [-ClientId <String>] [-RedirectUri <String>] [-LoginPrompt <String>] [-IsEncrypted 
<Boolean>] [-Quiet] [<CommonParameters>]
``` 

## Examples

```Powershell 
Connect-XrmClient -Url "https://contoso.crm.dynamics.com";
``` 


```Powershell 
" -ClientSecret "<secret>";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



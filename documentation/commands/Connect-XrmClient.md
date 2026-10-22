# Command : `Connect-XrmClient` 

## Description

**Connect to Microsoft Dataverse without manually composing a connection string.** : Build a Dataverse connection string from explicit authentication parameters or from a URL-only interactive login scenario, then delegate the connection to New-XrmClient.
With AccessToken or AccessTokenProvider, connect with an access token obtained elsewhere (Azure PowerShell, Azure CLI, MSAL, managed identity...), without connection string.

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
Quiet|SwitchParameter|named|false|False|Do not display the connection message.
AccessToken|Object|named|true||Access token for the environment: a string, a SecureString, or an object with a Token or AccessToken property (result of Get-AzAccessToken, MSAL AuthenticationResult). It is not renewed: once it expires (about one hour after it was issued), every request fails with an error giving its expiry. Use AccessTokenProvider for a longer session.
AccessTokenProvider|ScriptBlock|named|true||Script block that returns an access token (same forms as AccessToken). It receives the environment URL (https://contoso.crm.dynamics.com) as its first argument. It is called at connection, then again when the token expires within 5 minutes (exp claim of the token; a token without this claim is asked for every request), so the session can outlast a token. It runs on the PowerShell thread that connected only: a clone of the client (Invoke-XrmParallelRequests, Publish-XrmComponent -TimeoutInMinutes) uses the last token while it is valid, and fails once it has expired.

## Outputs
Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

## Usage

```Powershell 
Connect-XrmClient -Url <String> [-UserName <String>] [-ClientId <String>] [-RedirectUri <String>] [-LoginPrompt <String>] [-IsEncrypted <Boolean>] [-Quiet] [<CommonParameters>]

Connect-XrmClient -Url <String> [-IsEncrypted <Boolean>] [-Quiet] -AccessTokenProvider <ScriptBlock> [<CommonParameters>]

Connect-XrmClient -Url <String> [-IsEncrypted <Boolean>] [-Quiet] -AccessToken <Object> [<CommonParameters>]

Connect-XrmClient -Url <String> -ClientId <String> -CertificateThumbprint <String> [-IsEncrypted <Boolean>] [-Quiet] [<CommonParameters>]

Connect-XrmClient -Url <String> -ClientId <String> -ClientSecret <String> [-IsEncrypted <Boolean>] [-Quiet] [<CommonParameters>]

Connect-XrmClient -Url <String> -UserName <String> -Password <String> [-ClientId <String>] [-RedirectUri <String>] [-LoginPrompt <String>] [-IsEncrypted <Boolean>] [-Quiet] [<CommonParameters>]
``` 

## Examples

```Powershell 
Connect-XrmClient -Url "https://contoso.crm.dynamics.com";
``` 


```Powershell 
" -ClientSecret "<secret>";
``` 


```Powershell 
$url = "https://contoso.crm.dynamics.com";
Connect-XrmClient -Url $url -AccessToken (az account get-access-token --resource $url --query accessToken --output tsv);
``` 


```Powershell 
# Token renewed during the session (Az.Accounts)
Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -AccessTokenProvider { param($url) Get-AzAccessToken -ResourceUrl $url };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



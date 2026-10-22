# Command : `New-XrmClient` 

## Description

**Initialize CrmServiceClient instance.** : Create a new connection to Microsoft Dataverse with a connectionstring.
An OAuth connection without password, secret or certificate signs in interactively. In a session that cannot show a sign-in prompt (started with -NonInteractive, no user desktop, remote session), it fails at once instead of waiting until the timeout, unless the connection string holds LoginPrompt=Never (silent sign-in only).
With Url and AccessToken or AccessTokenProvider, the connection uses an access token obtained elsewhere (Azure PowerShell, Azure CLI, MSAL, managed identity...): the module does not sign in.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false||Connection String to Microsoft Dataverse instance (https://docs.microsoft.com/fr-fr/powerapps/developer/common-data-service/xrm-tooling/use-connection-strings-xrm-tooling-connect)
MaxCrmConnectionTimeOutMinutes|Int32|2|false|2|Specify timeout duration in minutes.
IsEncrypted|Boolean|3|false|False|Specify if password or secret are encrypted.
Quiet|SwitchParameter|named|false|False|Do not display the connection message.
ConfigPath|String|4|false||Configuration file holding the connection string, in the standard .NET format (connectionStrings.config, app.config...), with ConnectionName, instead of ConnectionString. See Get-XrmConnectionString.
ConnectionName|String|5|false||Name of the connection string entry in ConfigPath.
Url|String|6|false||Environment URL (https://contoso.crm.dynamics.com), with AccessToken or AccessTokenProvider instead of ConnectionString.
AccessToken|Object|7|false||Access token for the environment, with Url: a string, a SecureString, or an object with a Token or AccessToken property (result of Get-AzAccessToken, MSAL AuthenticationResult). It is not renewed: once it expires (about one hour after it was issued), every request fails with an error giving its expiry. Use AccessTokenProvider for a longer session.
AccessTokenProvider|ScriptBlock|8|false||Script block that returns an access token (same forms as AccessToken), with Url. It receives the environment URL (https://contoso.crm.dynamics.com) as its first argument. It is called at connection, then again when the token expires within 5 minutes (exp claim of the token; a token without this claim is asked for every request), so the session can outlast a token. It runs on the PowerShell thread that connected only: a clone of the client (Invoke-XrmParallelRequests, Publish-XrmComponent -TimeoutInMinutes) uses the last token while it is valid, and fails once it has expired.

## Outputs
Microsoft.PowerPlatform.Dataverse.Client.ServiceClient. Microsoft Dataverse connector.

## Usage

```Powershell 
New-XrmClient [[-ConnectionString] <String>] [[-MaxCrmConnectionTimeOutMinutes] <Int32>] [[-IsEncrypted] <Boolean>] [-Quiet] [[-ConfigPath] <String>] [[-ConnectionName] <String>] [[-Url] <String>] [[-AccessToken] <Object>] [[-AccessTokenProvider] <ScriptBlock>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
``` 


```Powershell 
$xrmClient = New-XrmClient -ConfigPath ".\connectionStrings.config" -ConnectionName "Dev";
``` 


```Powershell 
$xrmClient = New-XrmClient -Url "https://contoso.crm.dynamics.com" -AccessTokenProvider { param($url) Get-AzAccessToken -ResourceUrl $url };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



# Command : `Connect-XrmAdmin` 

## Description

**Use Add-PowerAppsAccount cmdlet signs in the user or application account and saves the sign in information to cache.** : Use this command to embed Power Apps Admin cmdlets
The module Microsoft.PowerApps.Administration.PowerShell is loaded here, on first use, not when PowerDataOps is imported. It is not installed automatically: install it with Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Scope CurrentUser.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
UserName|String|1|false||User login
Password|String|2|false||User password
TenantId|String|3|false||AAD tenant ID (use with Client ID / secret)
ApplicationId|String|4|false||AAD Application ID
ClientSecret|String|5|false||AAD Application secret
CertificateThumbprint|String|6|false||AAD Application Certificate Thumbprint
IsEncrypted|Boolean|7|false|False|Specify if password or secret are encrypted.


## Usage

```Powershell 
Connect-XrmAdmin [[-UserName] <String>] [[-Password] <String>] [[-TenantId] <String>] [[-ApplicationId] <String>] [[-ClientSecret] <String>] [[-CertificateThumbprint] <String>] [[-IsEncrypted] <Boolean>] [<CommonParameters>]
``` 



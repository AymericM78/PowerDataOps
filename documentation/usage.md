# Use `PowerDataOps` Module

Once module installation is done, you need to load module before use it.
## Load module


```
Import-Module PowerDataOps -DisableNameChecking
```

Adding parameter DisableNameChecking hide unapproved verbs warning.
2 verbs are actually not approved but used in this module : ForEach and Upsert

## Connect to Microsoft Dataverse

Asof today, Microsoft Dataverse authentication scenarios are not fully compatible to provided toolings.
- Office365 authentication is not recommended and depraction is coming, but Get-CrmOrganizations cmdlet does not supports oAuth
- OAuth authentication seems to be not available yet for Environment mangement with Microsoft.PowerApps.Administration.PowerShell module.

So I'm not able to define 1 way to connect.

### Get-XrmClient

This cmdlet initialize a CrmServiceClient object to interact with Microsoft Dataverse.
You need to provide a connection string : https://docs.microsoft.com/fr-fr/powerapps/developer/data-platform/xrm-tooling/use-connection-strings-xrm-tooling-connect

```
Get-XrmClient -ConnectionString "AuthType=ClientSecret;url=https://contosotest.crm.dynamics.com;ClientId={AppId};ClientSecret={ClientSecret}"
```
### Connect-XrmUser

This cmdlet authenticate user in order to be able to discover environnements (=> Get-XrmInstances)
Parameters are the same as Get-CrmOrganizations : https://docs.microsoft.com/en-us/powershell/module/microsoft.xrm.tooling.crmconnector.powershell/get-crmorganizations?view=pa-ps-latest

```
Connect-XrmUser -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
```


### Connect-XrmAdmin

This cmdlet authenticate admin user in order to manage environments with  Microsoft.PowerApps.Administration.PowerShell module.
Parameters are the same as Add-PowerAppsAccount : https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/add-powerappsaccount?view=pa-ps-latest

```
Connect-XrmAdmin -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
```
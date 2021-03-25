# Use `PowerDataOps` Module

Once [PowerDataOps module installation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/install.md) is done, you need to load module before use it.

## Load module

```powershell
Import-Module PowerDataOps -DisableNameChecking
```

Adding parameter `-DisableNameChecking` hide unapproved verbs warning.
2 verbs are actually not approved but used in this module : `ForEach` and `Upsert`

## Connect to Microsoft Dataverse

Asof today, Microsoft Dataverse authentication scenarios are not fully compatible to provided toolings.

- [Office365 authentication is not recommended and deprecation is coming](https://docs.microsoft.com/fr-fr/power-platform/important-changes-coming#deprecation-of-office365-authentication-type-and-organizationserviceproxy-class-for-connecting-to-dataverse), but [`Get-CrmOrganizations`](https://docs.microsoft.com/en-us/powershell/module/microsoft.xrm.tooling.crmconnector.powershell/get-crmorganizations?view=pa-ps-latest) cmdlet does not supports oAuth
- OAuth authentication seems to be not available yet for Environment mangement with [Microsoft.PowerApps.Administration.PowerShell](https://docs.microsoft.com/en-us/power-platform/admin/powerapps-powershell#power-apps-cmdlets-for-administrators) module.

So I'm not able to define 1 way to connect.

### New-XrmClient

This cmdlet initialize a CrmServiceClient object to interact with Microsoft Dataverse.
You need to provide a connection string [`-ConnectionString`](https://docs.microsoft.com/fr-fr/powerapps/developer/data-platform/xrm-tooling/use-connection-strings-xrm-tooling-connect)

```powershell
New-XrmClient -ConnectionString "AuthType=ClientSecret;url=https://contosotest.crm.dynamics.com;ClientId={AppId};ClientSecret={ClientSecret}"
```

### Connect-XrmUser

This cmdlet authenticate user in order to be able to discover environnements (=> Get-XrmInstances)
Parameters are the same as [`Get-CrmOrganizations`](https://docs.microsoft.com/en-us/powershell/module/microsoft.xrm.tooling.crmconnector.powershell/get-crmorganizations?view=pa-ps-latest)

```powershell
Connect-XrmUser -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
```

### Connect-XrmAdmin

This cmdlet authenticate admin user in order to manage environments with  Microsoft.PowerApps.Administration.PowerShell module.
Parameters are the same as [`Add-PowerAppsAccount`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/add-powerappsaccount?view=pa-ps-latest)

```powershell
Connect-XrmAdmin -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
```

## Next steps

- [Samples](https://github.com/AymericM78/PowerDataOps/tree/main/documentation/samples)

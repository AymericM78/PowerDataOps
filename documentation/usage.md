# Use `PowerDataOps` Module

Once [PowerDataOps module installation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/install.md) is done, you need to load module before use it.

## Load module

```powershell
Import-Module PowerDataOps -DisableNameChecking
```

Adding parameter `-DisableNameChecking` hide unapproved verbs warning.
2 verbs are actually not approved but used in this module : `ForEach` and `Upsert`

### New-XrmClient

This cmdlet initialize a CrmServiceClient object to interact with Microsoft Dataverse.
You need to provide a connection string [`-ConnectionString`](https://docs.microsoft.com/fr-fr/powerapps/developer/data-platform/xrm-tooling/use-connection-strings-xrm-tooling-connect)

```powershell
New-XrmClient -ConnectionString "AuthType=ClientSecret;url=https://contosotest.crm.dynamics.com;ClientId={AppId};ClientSecret={ClientSecret}"
```

New-XrmClient command will try to run Connect-XrmAdmin automatically.

### Connect-XrmAdmin

This cmdlet authenticate admin user in order to manage environments with  Microsoft.PowerApps.Administration.PowerShell module.
Parameters are the same as [`Add-PowerAppsAccount`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/add-powerappsaccount?view=pa-ps-latest)

```powershell
Connect-XrmAdmin -AuthType Office365 -UserName "user@contoso.fake" -Password "MyPass123"
```

## Next steps

- [Samples](https://github.com/AymericM78/PowerDataOps/tree/main/documentation/samples)

# Use `PowerDataOps` Module

Once [PowerDataOps module installation](https://github.com/AymericM78/PowerDataOps/blob/main/documentation/install.md) is done, you need to load module before use it.

## Load module

```powershell
Import-Module PowerDataOps -DisableNameChecking
```

Adding parameter `-DisableNameChecking` hide unapproved verbs warning.
2 verbs are actually not approved but used in this module : `ForEach` and `Upsert`

### Connect-XrmClient

This cmdlet is the recommended way to connect to Microsoft Dataverse when you do not want to compose a raw connection string manually.

Interactive sign-in with only the Dataverse URL:

```powershell
Connect-XrmClient -Url "https://contoso.crm.dynamics.com";
```

Interactive sign-in with a login hint:

```powershell
Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -UserName "user@contoso.com";
```

Application authentication with client secret:

```powershell
Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -ClientId "<app-id>" -ClientSecret "<secret>";
```

Application authentication with certificate:

```powershell
Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -ClientId "<app-id>" -CertificateThumbprint "<thumbprint>";
```

Username / password authentication:

```powershell
Connect-XrmClient -Url "https://contoso.crm.dynamics.com" -UserName "user@contoso.com" -Password "MyPass123";
```

### New-XrmClient

This cmdlet initialize a CrmServiceClient object to interact with Microsoft Dataverse.
Use it when you already have a raw [`-ConnectionString`](https://docs.microsoft.com/fr-fr/powerapps/developer/data-platform/xrm-tooling/use-connection-strings-xrm-tooling-connect).

At minimum, the connection string must contain `Url=<DataverseUrl>`. If `Url` is the only authentication-related value provided, `New-XrmClient` automatically applies interactive OAuth defaults.

Interactive sign-in from a minimal connection string:

```powershell
New-XrmClient -ConnectionString "Url=https://contoso.crm.dynamics.com";
```

Explicit client-secret connection string:

```powershell
New-XrmClient -ConnectionString "AuthType=ClientSecret;Url=https://contosotest.crm.dynamics.com;ClientId={AppId};ClientSecret={ClientSecret}";
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

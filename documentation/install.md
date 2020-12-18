# Installing `PowerXrm` Module

## Overview

By default, modules are installed from the [PowerShell Gallery](https://www.powershellgallery.com/), which is the central repository for accessing published PowerShell modules (equivalent to NuGet for .NET, npm for JavaScript, etc.). With the [`Install-Module`](https://docs.microsoft.com/en-us/powershell/module/powershellget/install-module) cmdlet, users can specify which modules they want to install; in addition, users can provide the `-Repository` parameter to specify which repository they want to install modules from (if this parameter isn't provided, then the cmdlet defaults to using PowerShell Gallery).

## Registering Repositories

In some cases, users will need to install modules from a different repository than the PowerShell Gallery -- this can be a new endpoint, or even a local folder containing `.nupkg` files. In either case, the [`Register-PSRepository`](https://docs.microsoft.com/en-us/powershell/module/powershellget/register-psrepository) cmdlet should be used to create a new local repository that can be used to install modules from.

Below is an example of registering a new repository from a local folder containing `.nupkg` files:

```
Register-PSRepository -Name "{{repository_name}}" -SourceLocation "{{folder_with_nupkg_files}}" -PackageManagementProvider NuGet -InstallationPolicy Trusted
```

## Installing Module

To install PowerXrm module from the PowerShell Gallery, run the following command:

```
Install-Module -Name "PowerXrm"
```

To install PowerXrm module from a specific repository, run the following command:

```
Install-Module -Name "PowerXrm" -Repository "{{repository_name}}"
```

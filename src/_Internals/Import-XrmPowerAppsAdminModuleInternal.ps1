<#
    Load Microsoft.PowerApps.Administration.PowerShell, needed by the admin commands only (Connect-XrmAdmin and the commands that require it).
    Loaded on demand instead of at module import: its nested Microsoft.PowerApps.AuthModule writes an "unapproved verbs" warning
    that -DisableNameChecking does not cover, and most sessions never use it.
    Never installs it: a missing module raises an error with the Install-Module command to run.
#>
function Import-XrmPowerAppsAdminModuleInternal {
    param()

    $moduleName = "Microsoft.PowerApps.Administration.PowerShell";
    if (Get-Module -Name $moduleName) {
        return;
    }
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        throw "The PowerDataOps admin commands need the module '$moduleName', which is not installed. Install it, then run the command again: Install-Module -Name $moduleName -Scope CurrentUser";
    }
    # The warning comes from the nested module's own import: -WarningAction does not reach it, the redirection does
    Import-Module -Name $moduleName -DisableNameChecking -Global -Verbose:$false 3>$null;
}

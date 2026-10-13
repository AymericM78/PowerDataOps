<#
    Integration Test: module load (known issues K02 and K06)
    A script run as "pwsh -File script.ps1 -WhatIf" sets $WhatIfPreference in the global scope, which the module sees while it loads and in every
    function: the aliases must still be created, the module folders too, and the log still written (K02).
    Microsoft.PowerApps.Administration.PowerShell is no longer loaded (nor installed) at import: it loads on demand, without the warning of its nested module (K06).
    Each case runs in a child pwsh with its own APPDATA folder; no Dataverse call.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$modulePath = (Resolve-Path "$PSScriptRoot\..\..\PowerDataOps.psd1").Path;
$workFolder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-moduleload-$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
New-Item -ItemType Directory -Path $workFolder | Out-Null;
$probePath = Join-Path $workFolder "probe.ps1";
Set-Content -Path $probePath -Value @'
[CmdletBinding(SupportsShouldProcess)]
param([string]$ModulePath, [switch]$LoadAdmin)
$importOutput = @(Import-Module $ModulePath -Force -DisableNameChecking 3>&1 6>$null);
$result = [ordered]@{
    WhatIfPreference  = [bool]$WhatIfPreference;
    RowValueAlias     = [bool](Get-Alias -Name Get-XrmRowValue -ErrorAction SilentlyContinue);
    ColumnAlias       = [bool](Get-Alias -Name New-StringColumn -ErrorAction SilentlyContinue);
    SolutionAlias     = [bool](Get-Alias -Name Remove-XrmSolution -ErrorAction SilentlyContinue);
    LogFolder         = (Test-Path -Path $Global:LogFolderPath);
    AdminModuleLoaded = [bool](Get-Module -Name Microsoft.PowerApps.Administration.PowerShell);
    ImportWarnings    = @($importOutput | Where-Object { $_ -is [System.Management.Automation.WarningRecord] } | ForEach-Object { $_.Message });
};
Write-HostAndLog -Message "pdo-probe-marker" 6>$null;
$result.LogWritten = (Test-Path -Path $Global:LogFilePath) -and ((Get-Content -Path $Global:LogFilePath -Raw) -match "pdo-probe-marker");
if ($LoadAdmin) {
    $result.AdminAvailable = [bool](Get-Module -ListAvailable -Name Microsoft.PowerApps.Administration.PowerShell);
    try {
        $adminOutput = @(& (Get-Module PowerDataOps) { Import-XrmPowerAppsAdminModuleInternal } 3>&1);
        $result.AdminWarnings = @($adminOutput | Where-Object { $_ -is [System.Management.Automation.WarningRecord] } | ForEach-Object { $_.Message });
    }
    catch {
        $result.AdminError = $_.Exception.Message;
    }
    $result.AdminModuleLoadedOnDemand = [bool](Get-Module -Name Microsoft.PowerApps.Administration.PowerShell);
}
"PDO-RESULT:" + ($result | ConvertTo-Json -Compress);
'@;

# Runs the probe in a child pwsh whose APPDATA is a new folder, and returns its result
function Invoke-ModuleProbe {
    param([string]$Name, [string[]]$Arguments = @())
    $appData = Join-Path $workFolder $Name;
    New-Item -ItemType Directory -Path $appData | Out-Null;
    $previousAppData = $env:APPDATA;
    try {
        $env:APPDATA = $appData;
        $output = & pwsh -NoProfile -File $probePath -ModulePath $modulePath @Arguments 2>&1;
    }
    finally {
        $env:APPDATA = $previousAppData;
    }
    $line = @($output | Where-Object { "$_" -like "PDO-RESULT:*" }) | Select-Object -Last 1;
    if (-not $line) {
        Write-Host ($output | Out-String) -ForegroundColor DarkGray;
        return $null;
    }
    return ("$line".Substring("PDO-RESULT:".Length) | ConvertFrom-Json);
}

# ============================================================
# K02: pwsh -File script.ps1 -WhatIf
# ============================================================
Write-Section "Module load under a global -WhatIf";

$dryRun = Invoke-ModuleProbe -Name "whatif" -Arguments @("-WhatIf");
Assert-Test "The probe ran with `$WhatIfPreference set globally (the reported case)" { $null -ne $dryRun -and $dryRun.WhatIfPreference };
Assert-Test "Aliases created: Get-XrmRowValue, New-StringColumn, Remove-XrmSolution" { $dryRun.RowValueAlias -and $dryRun.ColumnAlias -and $dryRun.SolutionAlias };
Assert-Test "Module log folder created" { $dryRun.LogFolder };
Assert-Test "Write-HostAndLog writes the log of the dry run" { $dryRun.LogWritten };

# ============================================================
# K06: admin module loaded on demand
# ============================================================
Write-Section "Microsoft.PowerApps.Administration.PowerShell on demand";

$normal = Invoke-ModuleProbe -Name "admin" -Arguments @("-LoadAdmin");
Assert-Test "Without -WhatIf: aliases and log as before" { $null -ne $normal -and -not $normal.WhatIfPreference -and $normal.RowValueAlias -and $normal.LogWritten };
Assert-Test "Import: the admin module is not loaded, no warning" { -not $normal.AdminModuleLoaded -and @($normal.ImportWarnings).Count -eq 0 };
if ($normal.AdminAvailable) {
    Assert-Test "On demand: loaded, without the 'unapproved verbs' warning" { $normal.AdminModuleLoadedOnDemand -and @($normal.AdminWarnings).Count -eq 0 -and $null -eq $normal.AdminError };
}
else {
    Assert-Test "On demand, module missing: error with the Install-Module command, nothing installed" { $normal.AdminError -like "*Install-Module -Name Microsoft.PowerApps.Administration.PowerShell*" -and -not $normal.AdminModuleLoadedOnDemand };
}

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
Remove-Item -Path $workFolder -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Work folder removed" { -not (Test-Path -Path $workFolder) };

Write-TestSummary;

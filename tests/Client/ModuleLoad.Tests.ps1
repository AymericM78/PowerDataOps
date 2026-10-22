<#
    Integration Test: module load (known issues K02 and K06, assembly loader)
    A script run as "pwsh -File script.ps1 -WhatIf" sets $WhatIfPreference in the global scope, which the module sees while it loads and in every
    function: the aliases must still be created, the module folders too, and the log still written (K02).
    Microsoft.PowerApps.Administration.PowerShell is no longer loaded (nor installed) at import: it loads on demand, without the warning of its nested module (K06).
    Assembly loader (2.0.0.67), in PowerShell 7 and Windows PowerShell 5.1: it runs once per import, a DLL that cannot load gives a warning, and its
    resolver answers with the module's own DLLs (even when another copy was loaded first), never for an assembly the module does not ship.
    Each case runs in a child process with its own APPDATA folder; no Dataverse call.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$modulePath = (Resolve-Path "$PSScriptRoot\..\..\PowerDataOps.psd1").Path;
$workFolder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-moduleload-$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
New-Item -ItemType Directory -Path $workFolder | Out-Null;
$probePath = Join-Path $workFolder "probe.ps1";
Set-Content -Path $probePath -Value @'
[CmdletBinding(SupportsShouldProcess)]
param([string]$ModulePath, [switch]$LoadAdmin, [string]$PreloadCopy)
# A copy of one of the module's DLLs loaded first, as another module shipping the same dependency would
if ($PreloadCopy) {
    $null = [System.Reflection.Assembly]::LoadFile($PreloadCopy);
}
# Counts the runs of the assembly loader during the import
$loaderPath = Join-Path (Split-Path $ModulePath) "src\_Internals\AssemblyLoader.ps1";
$loaderLine = (Select-String -LiteralPath $loaderPath -Pattern '^\$Global:PowerDataOpsAssemblyPath').LineNumber;
$Global:LoaderRuns = 0;
$null = Set-PSBreakpoint -Script $loaderPath -Line $loaderLine -Action { $Global:LoaderRuns++ };
$importOutput = @(Import-Module $ModulePath -Force -DisableNameChecking 3>&1 6>$null);
Get-PSBreakpoint | Remove-PSBreakpoint -WhatIf:$false;
$result = [ordered]@{
    LoaderRuns        = $Global:LoaderRuns;
    AssemblyFolder    = $Global:PowerDataOpsAssemblyPath;
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
# One of the module's DLLs, asked in the version its neighbours reference (3.1.0, another one is shipped)
try {
    $result.OwnResolvedFrom = [System.Reflection.Assembly]::Load("Microsoft.Extensions.Primitives, Version=3.1.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60").Location;
}
catch {
    $result.OwnResolvedFrom = "ERROR: $($_.Exception.Message)";
}
# An assembly the module does not ship, already loaded, asked in a version that does not exist (the resolver of 2.0.0.66 answered with the loaded one)
try {
    $result.ForeignResolved = [System.Reflection.Assembly]::Load("System.Management.Automation, Version=99.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35").FullName;
}
catch {
    $result.ForeignResolved = $null;
}
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

# Runs the probe in a child process (pwsh, or powershell.exe for Windows PowerShell 5.1) whose APPDATA is a new folder, and returns its result
function Invoke-ModuleProbe {
    param([string]$Name, [string[]]$Arguments = @(), [string]$Shell = "pwsh")
    $appData = Join-Path $workFolder $Name;
    New-Item -ItemType Directory -Path $appData | Out-Null;
    $previousAppData = $env:APPDATA;
    try {
        $env:APPDATA = $appData;
        $output = & $Shell -NoProfile -ExecutionPolicy Bypass -File $probePath -ModulePath $modulePath @Arguments 2>&1;
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
# Assembly loader, in each edition (Assemblies\Core, Assemblies\Desktop)
# ============================================================
Write-Section "Assembly loader";

# The loader alone, next to a DLL that cannot load
$brokenRoot = Join-Path $workFolder "broken";
New-Item -ItemType Directory -Path "$brokenRoot\_Internals", "$brokenRoot\Assemblies\Core", "$brokenRoot\Assemblies\Desktop" | Out-Null;
Copy-Item -LiteralPath (Join-Path (Split-Path $modulePath) "src\_Internals\AssemblyLoader.ps1") -Destination "$brokenRoot\_Internals";
Set-Content -Path "$brokenRoot\Assemblies\Core\Broken.dll", "$brokenRoot\Assemblies\Desktop\Broken.dll" -Value "not an assembly";
$brokenProbePath = Join-Path $workFolder "broken-probe.ps1";
Set-Content -Path $brokenProbePath -Value 'param([string]$LoaderPath) . $LoaderPath 3>&1 | ForEach-Object { "PDO-WARNING:$_" }';

$shells = @("pwsh");
if (Get-Command -Name powershell.exe -ErrorAction SilentlyContinue) {
    $shells += "powershell.exe";
}
else {
    Write-Host "  [SKIP] Windows PowerShell 5.1 not installed: Assemblies\Desktop not checked" -ForegroundColor Yellow;
}
foreach ($shell in $shells) {
    $edition = if ($shell -eq "pwsh") { "Core" } else { "Desktop" };

    $loader = Invoke-ModuleProbe -Name "loader-$edition" -Shell $shell;
    Assert-Test "$($edition): the loader runs once per import (it also ran from the function file loop until 2.0.0.66)" { $null -ne $loader -and $loader.LoaderRuns -eq 1 };
    Assert-Test "$($edition): every DLL loads, no warning" { $null -ne $loader -and @($loader.ImportWarnings).Count -eq 0 };
    Assert-Test "$($edition): a module DLL asked in another version resolves to the shipped one" { $null -ne $loader -and $loader.OwnResolvedFrom -like "$($loader.AssemblyFolder)\*" };
    Assert-Test "$($edition): an assembly the module does not ship is left to the runtime" { $null -ne $loader -and -not $loader.ForeignResolved };

    if ($null -ne $loader) {
        $copyPath = Join-Path $workFolder "preload-$edition.dll";
        Copy-Item -LiteralPath (Join-Path $loader.AssemblyFolder "Microsoft.Extensions.Primitives.dll") -Destination $copyPath;
        $preloaded = Invoke-ModuleProbe -Name "preload-$edition" -Shell $shell -Arguments @("-PreloadCopy", $copyPath);
        Assert-Test "$($edition): with another copy loaded first, the module's own copy is resolved" { $null -ne $preloaded -and $preloaded.OwnResolvedFrom -like "$($preloaded.AssemblyFolder)\*" };
    }

    $brokenOutput = & $shell -NoProfile -ExecutionPolicy Bypass -File $brokenProbePath -LoaderPath "$brokenRoot\_Internals\AssemblyLoader.ps1" 2>&1;
    Assert-Test "$($edition): a DLL that cannot load gives a warning naming it" { @($brokenOutput | Where-Object { "$_" -like "PDO-WARNING:*cannot load*Broken.dll*" }).Count -eq 1 };
}

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
Remove-Item -Path $workFolder -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Work folder removed" { -not (Test-Path -Path $workFolder) };

Write-TestSummary;

<#
    Integration Test: Linux and macOS support (2.0.0.69)
    Checked from Windows, without Dataverse call:
    - the module folder does not depend on APPDATA, which Linux and macOS lack (a child pwsh without APPDATA);
    - src reads neither $env:TEMP nor $env:APPDATA (except Get-XrmAppDataPathInternal), and writes no "$variable\path" outside the
      Windows-only commands: .NET does not read "\" as a separator on Linux and macOS;
    - the Windows-only commands raise an error naming the feature.
    The display check of the interactive sign-in is in Client\Connection.Tests.ps1, the platform builds of Assemblies\Core in Client\ModuleLoad.Tests.ps1.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$moduleScope = Get-Module PowerDataOps;
$modulePath = (Resolve-Path "$PSScriptRoot\..\..\PowerDataOps.psd1").Path;
$srcPath = Join-Path (Split-Path $modulePath) "src";

# ============================================================
# Module folder without APPDATA
# ============================================================
Write-Section "Module folder without APPDATA (Linux, macOS)";

$command = "Import-Module '$modulePath' -DisableNameChecking 6>`$null | Out-Null; 'PDO-RESULT:' + (@{ ModuleFolder = `$Global:PowerDataOpsModuleFolderPath; LogFolder = `$Global:LogFolderPath; ApplicationData = [System.Environment]::GetFolderPath('ApplicationData') } | ConvertTo-Json -Compress)";
$previousAppData = $env:APPDATA;
try {
    $env:APPDATA = $null;
    $output = & pwsh -NoProfile -Command $command 2>&1;
}
finally {
    $env:APPDATA = $previousAppData;
}
$resultLine = @($output | Where-Object { "$_" -like "PDO-RESULT:*" }) | Select-Object -Last 1;
$probe = if ($resultLine) { "$resultLine".Substring("PDO-RESULT:".Length) | ConvertFrom-Json } else { $null };
if (-not $probe) {
    Write-Host ($output | Out-String) -ForegroundColor DarkGray;
}
Assert-Test "Module folder in the user's application data folder, not a relative path ($($probe.ModuleFolder))" {
    $null -ne $probe -and [System.IO.Path]::IsPathRooted($probe.ModuleFolder) -and $probe.ModuleFolder -eq [System.IO.Path]::Combine($probe.ApplicationData, "PowerDataOps");
};
Assert-Test "Log folder created there" { $null -ne $probe -and (Test-Path -LiteralPath $probe.LogFolder) };
Assert-Test "With APPDATA: APPDATA, as before" { (& $moduleScope { Get-XrmAppDataPathInternal }) -eq $env:APPDATA };

# ============================================================
# Static checks
# ============================================================
Write-Section "Static checks on src";

# Windows-only commands, guarded by Assert-XrmWindowsInternal: their Windows paths stay
$windowsOnlyFiles = @("Export-XrmConnectionToBrowser.ps1", "BrowserManager.ps1");
$environmentReads = [System.Collections.Generic.List[string]]::new();
$backslashPaths = [System.Collections.Generic.List[string]]::new();
foreach ($file in Get-ChildItem -LiteralPath $srcPath -Recurse -Filter "*.ps1") {
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$null);
    foreach ($variable in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.VariableExpressionAst] }, $true)) {
        if ($variable.VariablePath.UserPath -match '^env:(TEMP|TMP|APPDATA)$' -and $file.Name -ne "Get-XrmAppDataPathInternal.ps1") {
            $environmentReads.Add("$($file.Name):$($variable.Extent.StartLineNumber) $($variable.Extent.Text)");
        }
    }
    if ($windowsOnlyFiles -contains $file.Name) {
        continue;
    }
    foreach ($string in $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.ExpandableStringExpressionAst] }, $true)) {
        if ($string.Value -match '\$(\w+|\{[^}]+\}|env:\w+|\([^)]*\))\\[\w.$]') {
            $backslashPaths.Add("$($file.Name):$($string.Extent.StartLineNumber) $($string.Extent.Text)");
        }
    }
}
Assert-Test "No `$env:TEMP / `$env:APPDATA read (use [System.IO.Path]::GetTempPath() and Get-XrmAppDataPathInternal)" { $environmentReads.Count -eq 0 };
$environmentReads | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray };
Assert-Test "No path written as `"`$variable\...`" (use [System.IO.Path]::Combine or Join-Path)" { $backslashPaths.Count -eq 0 };
$backslashPaths | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray };

# ============================================================
# Windows-only commands
# ============================================================
Write-Section "Windows-only commands";

Assert-Test "Windows: no error" { $null -eq (& $moduleScope { Assert-XrmWindowsInternal -Feature "Excel automation (COM)" }) };
$errorMessage = $null;
try {
    & $moduleScope { Assert-XrmWindowsInternal -Feature "SolutionPackager.exe (.NET Framework)" -Alternative "Use pac solution unpack." -Platform Unix };
}
catch {
    $errorMessage = $_.Exception.Message;
}
Assert-Test "Linux, macOS: error naming the feature and the alternative" { $errorMessage -eq "SolutionPackager.exe (.NET Framework) is only available on Windows. Use pac solution unpack." };
$guardedCommands = @("Read-XrmExcelSheet", "Write-XrmExcelSheet", "Export-XrmConnectionToBrowser", "Invoke-XrmSolutionPackager");
Assert-Test "Guarded: $($guardedCommands -join ', ')" {
    @($guardedCommands | Where-Object { (Get-Command -Name $_ -Module PowerDataOps).ScriptBlock.ToString() -match 'Assert-XrmWindowsInternal' }).Count -eq $guardedCommands.Count;
};

Write-TestSummary;

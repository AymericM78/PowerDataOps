. "$PSScriptRoot\src\_Internals\AssemblyLoader.ps1";

# Discover and load function scripts
Write-Verbose "----- LOAD FUNCTIONS -----";
$scriptFiles = @(Get-ChildItem -Path "$PSScriptRoot\src\" -Include "*.ps1" -Recurse);
foreach ($scriptFile in $scriptFiles) {
    $scriptPath = $scriptFile.FullName;
    Write-Verbose " > Loading function file '$scriptPath'";
    try {
        . $scriptPath;
        Write-Verbose " > Loading function file '$scriptPath' => OK !";
    }
    catch {
        $errorMessage = $_.Exception.Message;
        Write-Warning "PowerDataOps: cannot load '$scriptPath', its commands are unavailable. Reason = '$errorMessage'";
    }
}

# Install and Import required modules
Write-Verbose "----- LOAD MODULES -----";
$requiredModules = @("Microsoft.PowerApps.Administration.PowerShell")
foreach ($module in $requiredModules) {
    if (-not(Get-Module -ListAvailable -Name $module)) {
        Write-Verbose "$module does not exist";
        Install-Module -Name $module -Scope CurrentUser -SkipPublisherCheck -Force -Confirm:$false -AllowClobber;
    }
    Import-Module -Name $module -DisableNameChecking;
    Write-Verbose " > Loading module : '$module' => OK !";
}

# Provision dedicate appdata folder
Write-Verbose "----- LOAD APPDATA FOLDER -----";
$Global:PowerDataOpsModuleFolderPath = [System.IO.Path]::Combine($env:APPDATA, "PowerDataOps");
New-Item -ItemType Directory -Path $Global:PowerDataOpsModuleFolderPath -Force | Out-Null;
Write-Verbose " > Initialize module folder '$($Global:PowerDataOpsModuleFolderPath)' => OK !";

# Initialize tracing file
$timestamp = Get-date -format "yyyy-MM-dd -- HH-mm-ss";
New-Item -ItemType Directory -Path $Global:PowerDataOpsModuleFolderPath -Name "Logs" -Force | Out-Null;
$Global:LogFolderPath = [System.IO.Path]::Combine($Global:PowerDataOpsModuleFolderPath, "Logs");
$Global:LogFilePath = [System.IO.Path]::Combine($Global:LogFolderPath, "$timestamp.log");

# Show the version being loaded (read from the manifest next to this file), then the other installed versions
$loadedVersion = (Import-PowerShellDataFile -Path "$PSScriptRoot\PowerDataOps.psd1").ModuleVersion;
Write-Host "PowerDataOps version = $loadedVersion";
$otherVersions = @(Get-Module -Name PowerDataOps -ListAvailable | Where-Object { $_.Version.ToString() -ne $loadedVersion } | ForEach-Object { $_.Version.ToString() } | Select-Object -Unique);
if ($otherVersions.Count -gt 0) {
    Write-Host "Other PowerDataOps versions installed: $($otherVersions -join ', ')" -ForegroundColor Yellow;
}

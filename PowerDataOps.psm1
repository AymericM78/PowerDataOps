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
        Write-Verbose " > Loading function file '$scriptPath' => KO ! Reason = '$errorMessage'";
    }
}

# Install and Import required modules
Write-Verbose "----- LOAD MODULES -----";
$requiredModules = @("Microsoft.PowerApps.Administration.PowerShell")
foreach ($module in $requiredModules) {
    if (-not(Get-Module -ListAvailable -Name $module)) {
        Write-Verbose "$module does not exist";
        Install-Module -Name $module -RequiredVersion "2.0.200" -Scope CurrentUser -SkipPublisherCheck -Force -Confirm:$false -AllowClobber;
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

$module = Get-Module -Name PowerDataOps -ListAvailable;
if (-not $module) {
    return;
}
if ($module.Count -gt 1) {
    Write-Host "Multiple PowerDataOps modules installed!" -ForegroundColor Yellow;
    foreach ($version in $module) {
        $moduleVersion = $version.Version.ToString();
        Write-Host " - version $moduleVersion";
    }
}
else {
    $moduleVersion = $module.Version.ToString();
    Write-Host "PowerDataOps version = $moduleVersion";
}


# Discover and load function scripts
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
$requiredModules = @("Microsoft.Xrm.Tooling.CrmConnector.PowerShell", "Microsoft.PowerApps.Administration.PowerShell")
foreach ($module in $requiredModules) {
    if (-not(Get-Module -ListAvailable -Name $module)) {
        Write-Verbose "$module does not exist";
        Install-Module -Name $module -Scope CurrentUser -SkipPublisherCheck -Force -Confirm:$false -AllowClobber;
    }
    else {
        # TODO : Update Module only if a newer version exist
        #Update-Module -Name $module -Scope CurrentUser -SkipPublisherCheck -Force -Confirm:$false -AllowClobber;
    }
    Import-Module -Name $module -DisableNameChecking;
}

# Provision dedicate appdata folder
$Global:PowerXrmModuleFolderPath = [System.IO.Path]::Combine($env:APPDATA, "PowerDataOps");
New-Item -ItemType Directory -Path $Global:PowerXrmModuleFolderPath -Force | Out-Null;

Write-Verbose "Module folder initialized : $($Global:PowerXrmModuleFolderPath)";

# Initialize tracing file
$timestamp = Get-date -format "yyyy-MM-dd -- HH-mm-ss";
New-Item -ItemType Directory -Path $Global:PowerXrmModuleFolderPath -Name "Logs" -Force | Out-Null;
$Global:LogFolderPath = [System.IO.Path]::Combine($Global:PowerXrmModuleFolderPath, "Logs");
$Global:LogFilePath = [System.IO.Path]::Combine($Global:LogFolderPath, "$timestamp.log");

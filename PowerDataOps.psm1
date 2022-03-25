
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
    Write-Verbose " > Loading module : '$module' => OK !";
}

# Loading assemblies
$binFolderPath = "$PSScriptRoot\src\Assemblies";
$assemblies = @("$binFolderPath\Microsoft.Xrm.Sdk.dll", "$binFolderPath\Microsoft.Crm.Sdk.Proxy.dll", "$binFolderPath\Microsoft.Xrm.Tooling.Connector.dll");
foreach ($assemblyPath in $assemblies) {
    Add-Type -Path $assemblyPath;
    Write-Verbose " > Loading assembly file '$assemblyPath' => OK !";
}

# Provision dedicate appdata folder
$Global:PowerDataOpsModuleFolderPath = [System.IO.Path]::Combine($env:APPDATA, "PowerDataOps");
New-Item -ItemType Directory -Path $Global:PowerDataOpsModuleFolderPath -Force | Out-Null;

Write-Verbose " > Initialize module folder '$($Global:PowerDataOpsModuleFolderPath)' => OK !";

# Initialize tracing file
$timestamp = Get-date -format "yyyy-MM-dd -- HH-mm-ss";
New-Item -ItemType Directory -Path $Global:PowerDataOpsModuleFolderPath -Name "Logs" -Force | Out-Null;
$Global:LogFolderPath = [System.IO.Path]::Combine($Global:PowerDataOpsModuleFolderPath, "Logs");
$Global:LogFilePath = [System.IO.Path]::Combine($Global:LogFolderPath, "$timestamp.log");

$module = Get-Module -Name PowerDataOps -ListAvailable;
if($module.Count -gt 1) {
    Write-Host "Multiple PowerDataOps modules installed!" -ForegroundColor Yellow;
    foreach($version in $module){
        $moduleVersion = $version.Version.ToString();
        Write-Host " - version $moduleVersion";
    }
}
else{
    $moduleVersion = $module.Version.ToString();
    Write-Host "PowerDataOps version = $moduleVersion";
}

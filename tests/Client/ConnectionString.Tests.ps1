<#
    Integration Test: connection strings from configuration files and logging (brief lot 8: C01, C02)
    Get-XrmConnectionString, New-XrmClient -ConfigPath -ConnectionName, Write-HostAndLog -LogFilePath, version shown at module load.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$folder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-config-$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
New-Item -ItemType Directory -Path $folder | Out-Null;

# ============================================================
# Get-XrmConnectionString
# ============================================================
Write-Section "Get-XrmConnectionString";

$standalonePath = Join-Path $folder "connectionStrings.config";
@"
<?xml version="1.0" encoding="utf-8"?>
<connectionStrings>
  <add name="Dev" connectionString="AuthType=OAuth;Url=https://dev.example.crm4.dynamics.com;LoginPrompt=Auto" />
  <add name="Test" connectionString="AuthType=OAuth;Url=https://test.example.crm4.dynamics.com;LoginPrompt=Auto" />
</connectionStrings>
"@ | Set-Content -Path $standalonePath;
$appConfigPath = Join-Path $folder "app.config";
@"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <connectionStrings>
    <add name="Prod" connectionString="AuthType=OAuth;Url=https://prod.example.crm4.dynamics.com;LoginPrompt=Auto" />
  </connectionStrings>
</configuration>
"@ | Set-Content -Path $appConfigPath;

Assert-Test "connectionStrings.config: entry read" { (Get-XrmConnectionString -ConfigPath $standalonePath -Name "Test") -eq "AuthType=OAuth;Url=https://test.example.crm4.dynamics.com;LoginPrompt=Auto" };
Assert-Test "Name compared without case" { (Get-XrmConnectionString -ConfigPath $standalonePath -Name "dev") -like "*dev.example*" };
Assert-Test "app.config (<configuration><connectionStrings>): entry read" { (Get-XrmConnectionString -ConfigPath $appConfigPath -Name "Prod") -like "*prod.example*" };
Assert-Test "Host shown with Out-XrmConnectionStringParameter" { (Get-XrmConnectionString -ConfigPath $standalonePath -Name "Dev" | Out-XrmConnectionStringParameter -ParameterName "Url") -eq "https://dev.example.crm4.dynamics.com" };

$missingEntry = $null;
try { Get-XrmConnectionString -ConfigPath $standalonePath -Name "Missing" | Out-Null; } catch { $missingEntry = $_.Exception.Message; }
Assert-Test "Unknown entry: error listing the available names" { $missingEntry -like "*Missing*not found*Dev, Test*" };
$missingFile = $null;
try { Get-XrmConnectionString -ConfigPath (Join-Path $folder "none.config") -Name "Dev" | Out-Null; } catch { $missingFile = $_.Exception.Message; }
Assert-Test "Unknown file: error" { $missingFile -like "*not found*" };

# ============================================================
# New-XrmClient -ConfigPath -ConnectionName
# ============================================================
Write-Section "New-XrmClient -ConfigPath -ConnectionName";

if ([string]::IsNullOrWhiteSpace($env:PDO_TEST_CONNECTIONSTRING)) {
    Write-Host "  [SKIP] PDO_TEST_CONNECTIONSTRING not set: interactive connections are not tested here" -ForegroundColor Yellow;
}
else {
    $secretConfigPath = Join-Path $folder "secret.config";
    $escaped = [System.Security.SecurityElement]::Escape($env:PDO_TEST_CONNECTIONSTRING);
    "<connectionStrings><add name=`"PdoTest`" connectionString=`"$escaped`" /></connectionStrings>" | Set-Content -Path $secretConfigPath;
    try {
        $client = New-XrmClient -ConfigPath $secretConfigPath -ConnectionName "PdoTest" -Quiet;
        Assert-Test "Connected through the configuration file" { $client.IsReady -and $null -ne (Get-XrmWhoAmI -XrmClient $client) };
    }
    finally {
        Remove-Item -Path $secretConfigPath -Force -ErrorAction SilentlyContinue;
    }
    $bothError = $null;
    try { New-XrmClient -ConnectionString "Url=https://x.crm.dynamics.com" -ConfigPath $standalonePath -ConnectionName "Dev" -Quiet | Out-Null; } catch { $bothError = $_.Exception.Message; }
    Assert-Test "ConnectionString with ConfigPath: error" { $bothError -like "*either*" };
}

# ============================================================
# Write-HostAndLog -LogFilePath
# ============================================================
Write-Section "Write-HostAndLog -LogFilePath";

$logPath = Join-Path $folder "custom.log";
$marker = "PDO log marker $([Guid]::NewGuid())";
Write-HostAndLog -Message $marker -LogFilePath $logPath 6>$null;
Assert-Test "Message written to the given file" { (Get-Content -Path $logPath -Raw) -like "*$marker*" };
Assert-Test "Not written to the session log" { -not ((Get-Content -Path $Global:LogFilePath -Raw -ErrorAction SilentlyContinue) -like "*$marker*") };

# ============================================================
# Version shown at module load
# ============================================================
Write-Section "Module load message";

$manifestPath = (Resolve-Path "$PSScriptRoot\..\..\PowerDataOps.psd1").Path;
$manifestVersion = (Import-PowerShellDataFile -Path $manifestPath).ModuleVersion;
$loadOutput = pwsh -NoProfile -NonInteractive -Command "Import-Module '$manifestPath' -Force -DisableNameChecking 3>`$null 6>&1" 2>&1 | ForEach-Object { "$_" };
Assert-Test "The loaded version ($manifestVersion) is shown" { @($loadOutput | Where-Object { $_ -eq "PowerDataOps version = $manifestVersion" }).Count -eq 1 };

Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue;
Write-TestSummary;

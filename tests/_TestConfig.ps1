<#
    PowerDataOps Integration Test Configuration
    
    This file is dot-sourced by all integration test scripts.
    It imports the module, connects to the Dataverse test instance,
    and provides helper functions for test execution.
#>

# Import module
Import-Module "$PsScriptRoot\..\PowerDataOps.psd1" -Force -DisableNameChecking;

# Connect to test instance.
# Unattended runs: set $env:PDO_TEST_CONNECTIONSTRING (e.g. AuthType=ClientSecret;Url=...;ClientId=...;ClientSecret=...).
# Never commit that value. Without it, interactive OAuth prompts once, then caches the token.
if (-not $Global:XrmClient -or -not $Global:XrmClient.IsReady) {
    if (-not [string]::IsNullOrWhiteSpace($env:PDO_TEST_CONNECTIONSTRING)) {
        $Global:XrmClient = New-XrmClient -ConnectionString $env:PDO_TEST_CONNECTIONSTRING;
    }
    else {
        $Global:XrmClient = Connect-XrmClient -Url "https://powerdataops.crm12.dynamics.com/";
    }
}

# Counters
$Global:TestPass = 0;
$Global:TestFail = 0;

# Helper: generate unique test name
function Get-TestName {
    param([string]$Prefix = "Test")
    return "$($Prefix)_IntTest_$(Get-Date -Format 'yyyyMMddHHmmss')_$([Guid]::NewGuid().ToString('N').Substring(0,6))";
}

# Helper: assert a condition and log result
function Assert-Test {
    param(
        [string]$Label,
        [scriptblock]$Condition
    )
    try {
        $result = Invoke-Command -ScriptBlock $Condition;
        if ($result) {
            $Global:TestPass++;
            Write-Host "  [PASS] $Label" -ForegroundColor Green;
        }
        else {
            $Global:TestFail++;
            Write-Host "  [FAIL] $Label" -ForegroundColor Red;
        }
    }
    catch {
        $Global:TestFail++;
        Write-Host "  [FAIL] $Label => $($_.Exception.Message)" -ForegroundColor Red;
    }
}

# Helper: compile a signed .NET Framework plugin assembly from C# source (tests that register plugins).
# Returns the DLL path, or $null when the .NET Framework compiler is not available (Windows only).
function New-TestPluginAssembly {
    param(
        [string]$AssemblyName,
        [string]$Source
    )
    $compiler = Join-Path "$env:WINDIR" "Microsoft.NET\Framework64\v4.0.30319\csc.exe";
    if (-not $env:WINDIR -or -not (Test-Path $compiler)) {
        return $null;
    }
    $folder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-plugin-$([Guid]::NewGuid().ToString('N').Substring(0,8))";
    New-Item -ItemType Directory -Path $folder | Out-Null;

    # Strong name key: a CSP private key blob marked as a signature key (like sn.exe -k)
    $rsa = [System.Security.Cryptography.RSACryptoServiceProvider]::new(1024);
    $keyBlob = $rsa.ExportCspBlob($true);
    $keyBlob[5] = 0x24;
    [System.IO.File]::WriteAllBytes("$folder\key.snk", $keyBlob);
    Set-Content -Path "$folder\plugin.cs" -Value $Source;

    $sdkPath = "$PSScriptRoot\..\src\Assemblies\Desktop\Microsoft.Xrm.Sdk.dll";
    $dllPath = "$folder\$AssemblyName.dll";
    $output = & $compiler /nologo /target:library "/out:$dllPath" "/keyfile:$folder\key.snk" "/reference:$sdkPath" "/reference:System.Runtime.Serialization.dll" "$folder\plugin.cs" 2>&1;
    if (-not (Test-Path $dllPath)) {
        throw "Plugin compilation failed: $output";
    }
    return $dllPath;
}

# Helper: write section header
function Write-Section {
    param([string]$Title)
    Write-Host "";
    Write-Host "=== $Title ===" -ForegroundColor Cyan;
}

# Helper: write summary
function Write-TestSummary {
    Write-Host "";
    Write-Host "========================================" -ForegroundColor White;
    Write-Host "  Total : $($Global:TestPass + $Global:TestFail) | Pass : $($Global:TestPass) | Fail : $($Global:TestFail)" -ForegroundColor $(if ($Global:TestFail -eq 0) { "Green" } else { "Red" });
    Write-Host "========================================" -ForegroundColor White;
}

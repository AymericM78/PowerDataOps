<#
    PowerDataOps Integration Test Configuration
    
    This file is dot-sourced by all integration test scripts.
    It imports the module, connects to the Dataverse test instance,
    and provides helper functions for test execution.
#>

# Import module
Import-Module "$PsScriptRoot\..\PowerDataOps.psd1" -Force;

# Connect to test instance (interactive OAuth — will prompt once, then cache token)
if (-not $Global:XrmClient -or -not $Global:XrmClient.IsReady) {
    $Global:XrmClient = New-XrmClient -ConnectionString "AuthType=OAuth;Url=https://powerdataops.crm12.dynamics.com/;AppId=51f81489-12ee-4a9e-aaae-a2591f45987d;RedirectUri=app://58145B91-0C36-4500-8554-080854F2AC97;LoginPrompt=Auto";
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

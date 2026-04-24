<#
    Master Test Runner
    Executes all integration test scripts in order.
    Usage: .\Run-AllTests.ps1
#>
param (
    [Parameter(Mandatory = $false)]
    [string[]]
    $Categories = @()
);

$ErrorActionPreference = "Continue";
$testRoot = $PSScriptRoot;

$allTests = @(
    @{ Category = "Types";         File = "Types\TypeHelpers.Tests.ps1" },
    @{ Category = "Utilities";     File = "Utilities\Initialize-XrmPath.Tests.ps1" },
    @{ Category = "Client";        File = "Client\Connection.Tests.ps1" },
    @{ Category = "Excel";         File = "Excel\Read-XrmExcelSheet.Tests.ps1" },
    @{ Category = "Metadata";      File = "Metadata\Set-XrmTableIcon.Tests.ps1" },
    @{ Category = "Query";         File = "Query\QueryExpression.Tests.ps1" },
    @{ Category = "Query";         File = "Query\QueryLinkColumns.Tests.ps1" },
    @{ Category = "Client";        File = "Client\RecordOperations.Tests.ps1" },
    @{ Category = "Client";        File = "Client\AccountCrud.Tests.ps1" },
    @{ Category = "Client";        File = "Client\Associations.Tests.ps1" },
    @{ Category = "Client";        File = "Client\DocumentTemplateContent.Tests.ps1" },
    @{ Category = "Client";        File = "Client\Export-XrmRecordToWord.Tests.ps1" },
    @{ Category = "Security";      File = "Security\Security.Tests.ps1" },
    @{ Category = "Security";      File = "Security\SecurityRoles.Tests.ps1" },
    @{ Category = "Organization";  File = "Organization\EnvironmentVariables.Tests.ps1" },
    @{ Category = "Email";         File = "Email\Email.Tests.ps1" },
    @{ Category = "Workflows";     File = "Workflows\Workflows.Tests.ps1" },
    @{ Category = "Plugins";       File = "Plugins\PluginSteps.Tests.ps1" },
    @{ Category = "Customization"; File = "Customization\Customization.Tests.ps1" },
    @{ Category = "Metadata";      File = "Metadata\MetadataCrud.Tests.ps1" },
    @{ Category = "Metadata";      File = "Metadata\ColumnTypes.Tests.ps1" },
    @{ Category = "Metadata";      File = "Metadata\OptionSetValues.Tests.ps1" },
    @{ Category = "Solutions";     File = "Solutions\Solutions.Tests.ps1" },
    @{ Category = "Solutions";     File = "Solutions\Add-XrmSolutionComponents.Tests.ps1" },
    @{ Category = "Solutions";     File = "Solutions\Test-XrmComponentCustomization.Tests.ps1" },
    @{ Category = "Solutions";     File = "Solutions\Get-XrmCustomizedSolutionComponents.Tests.ps1" },
    @{ Category = "Views";         File = "Views\Export-XrmViewToExcel.Tests.ps1" },
    @{ Category = "Client";        File = "Client\Sync-XrmRecords.Tests.ps1" }
);

# Filter by category if specified
if ($Categories.Count -gt 0) {
    $allTests = $allTests | Where-Object { $Categories -contains $_.Category };
}

$totalPassed = 0;
$totalFailed = 0;
$totalSkipped = 0;
$failedFiles = @();

Write-Host "`n========================================" -ForegroundColor Cyan;
Write-Host "  PowerDataOps Integration Test Suite" -ForegroundColor Cyan;
Write-Host "  $($allTests.Count) test files to run" -ForegroundColor Cyan;
Write-Host "========================================`n" -ForegroundColor Cyan;

foreach ($test in $allTests) {
    $filePath = Join-Path $testRoot $test.File;
    if (-not (Test-Path $filePath)) {
        Write-Host "[MISSING] $($test.File)" -ForegroundColor Red;
        $totalSkipped++;
        continue;
    }

    Write-Host "`n========================================" -ForegroundColor DarkCyan;
    Write-Host "  Running: $($test.File)" -ForegroundColor DarkCyan;
    Write-Host "========================================" -ForegroundColor DarkCyan;

    try {
        & $filePath;
    }
    catch {
        Write-Host "  [FATAL] $($test.File): $($_.Exception.Message)" -ForegroundColor Red;
        $totalFailed++;
        $failedFiles += $test.File;
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan;
Write-Host "  All Tests Complete" -ForegroundColor Cyan;
if ($failedFiles.Count -gt 0) {
    Write-Host "  Files with errors:" -ForegroundColor Red;
    foreach ($f in $failedFiles) {
        Write-Host "    - $f" -ForegroundColor Red;
    }
}
Write-Host "========================================`n" -ForegroundColor Cyan;

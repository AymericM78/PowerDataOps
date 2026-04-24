<#!
    Integration Test: Initialize-XrmPath cmdlet
    Validates directory and file path initialization.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Initialize Directory Path";

$rootPath = Join-Path $env:TEMP (Get-TestName -Prefix 'InitPath');
$directoryPath = Join-Path $rootPath 'Exports';
$filePath = Join-Path $directoryPath 'Accounts\Export.xlsx';

$initializedDirectoryPath = Initialize-XrmPath -Path $directoryPath;
Assert-Test "Initialize-XrmPath creates the directory" {
    (Test-Path $initializedDirectoryPath) -and (Get-Item $initializedDirectoryPath).PSIsContainer;
};

Write-Section "Initialize File Path";

$initializedFilePath = Initialize-XrmPath -Path $filePath -AsFilePath;
Assert-Test "Initialize-XrmPath -AsFilePath returns the original file path" {
    $initializedFilePath -eq $filePath;
};
Assert-Test "Initialize-XrmPath -AsFilePath creates the parent directory" {
    Test-Path ([System.IO.Path]::GetDirectoryName($filePath));
};

Write-Section "Cleanup";
if (Test-Path $rootPath) {
    Remove-Item -Path $rootPath -Recurse -Force;
}
Assert-Test "Temporary directory tree deleted" {
    -not (Test-Path $rootPath);
};

Write-TestSummary;
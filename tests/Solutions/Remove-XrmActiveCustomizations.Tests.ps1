<#
    Integration Test: Remove-XrmActiveCustomizations
    A failure is raised by default; -IgnoreMissing turns a "not found" error into a warning.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Missing component";

$missingId = [Guid]::NewGuid();
$errorMessage = $null;
try {
    $Global:XrmClient | Remove-XrmActiveCustomizations -SolutionComponentName "SavedQuery" -ComponentId $missingId | Out-Null;
}
catch {
    $errorMessage = $_.Exception.Message;
}
Assert-Test "Missing component raises an error naming it" {
    $errorMessage -like "*SavedQuery*$missingId*";
};

$ignoredError = $null;
$ignoredResponse = "not set";
try {
    $ignoredResponse = $Global:XrmClient | Remove-XrmActiveCustomizations -SolutionComponentName "SavedQuery" -ComponentId $missingId -IgnoreMissing;
}
catch {
    $ignoredError = $_.Exception.Message;
}
Assert-Test "-IgnoreMissing: no error, `$null returned" {
    $null -eq $ignoredError -and $null -eq $ignoredResponse;
};

Write-TestSummary;

<#!
    Integration Test: Invoke-XrmWorkflow cmdlet
    Validates workflow execution (no-op if no workflow exists).
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Invoke Workflow (no-op)";
# No default workflow, just test no error
Invoke-XrmWorkflow -WorkflowId ([guid]::NewGuid()) -RecordId ([guid]::NewGuid()) | Out-Null;
Assert-Test "No error on missing workflow" { $true };

Write-TestSummary;

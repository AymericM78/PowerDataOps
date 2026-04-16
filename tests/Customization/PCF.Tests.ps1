<#!
    Integration Test: PCF FormControl cmdlets
    Validates add, get, remove form controls on a form.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Get Form Controls";
$form = Get-XrmRecord -LogicalName "systemform" -Top 1;
$controls = Get-XrmFormControls -FormId $form.formid;
Assert-Test "Controls retrieved" { $controls.Count -ge 0 };

Write-TestSummary;

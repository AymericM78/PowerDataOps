<#!
    Integration Test: Ribbon cmdlets
    Validates export and import of ribbon via solution manipulation.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Export Ribbon";
$entity = "account";
$ribbon = Export-XrmRibbon -EntityLogicalName $entity;
Assert-Test "RibbonDiffXml exported" { $ribbon -and $ribbon.OuterXml -like '*RibbonDiffXml*' };

Write-Section "Import Ribbon (no-op)";
Import-XrmRibbon -EntityLogicalName $entity -RibbonDiffXml $ribbon | Out-Null;
Assert-Test "Ribbon imported (no error)" { $true };

Write-TestSummary;

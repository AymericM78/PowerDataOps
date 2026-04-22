<#!
    Integration Test: AppComponent cmdlets
    Validates add/remove/get app module components.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Create App Module for Component";
$name = Get-TestName -Prefix "AppComp";
$uniqueName = $name.Replace("-", "");
$app = Add-XrmAppModule -Name $name -UniqueName $uniqueName;
Assert-Test "AppModule created" { $app -and $app.appmoduleid };

Write-Section "Add Component (SavedQuery)";
$view = Get-XrmRecord -LogicalName "savedquery" -Top 1;
Add-XrmAppComponent -AppModuleId $app.appmoduleid -ComponentType 26 -ComponentId $view.savedqueryid | Out-Null;
$components = Get-XrmAppComponents -AppModuleId $app.appmoduleid;
Assert-Test "Component added" { $components | Where-Object { $_.ComponentId -eq $view.savedqueryid } };

Write-Section "Remove Component";
Remove-XrmAppComponent -AppModuleId $app.appmoduleid -ComponentType 26 -ComponentId $view.savedqueryid | Out-Null;
$components2 = Get-XrmAppComponents -AppModuleId $app.appmoduleid;
Assert-Test "Component removed" { -not ($components2 | Where-Object { $_.ComponentId -eq $view.savedqueryid }) };

Write-Section "Cleanup";
Remove-XrmAppModule -AppModuleId $app.appmoduleid | Out-Null;
Write-TestSummary;

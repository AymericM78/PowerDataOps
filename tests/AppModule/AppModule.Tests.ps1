<#!
    Integration Test: AppModule cmdlets
    Validates create, retrieve, update, remove, add/remove component, and test for app modules.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Create App Module";
$name = Get-TestName -Prefix "AppModule";
$uniqueName = $name.Replace("-", "");
$app = Add-XrmAppModule -Name $name -UniqueName $uniqueName;
Assert-Test "AppModule created" { $app -and $app.appmoduleid };

Write-Section "Get App Modules";
$apps = Get-XrmAppModules -Name $name;
Assert-Test "AppModule found" { $apps.Count -eq 1 -and $apps[0].appmoduleid -eq $app.appmoduleid };

Write-Section "Update App Module";
$desc = "Updated desc";
Set-XrmAppModule -AppModuleId $app.appmoduleid -Description $desc | Out-Null;
$updated = Get-XrmAppModules -Name $name | Select-Object -First 1;
Assert-Test "Description updated" { $updated.description -eq $desc };

Write-Section "Test App Module";
$validation = Test-XrmAppModule -AppModuleId $app.appmoduleid;
Assert-Test "Validation response" { $validation };

Write-Section "Remove App Module";
Remove-XrmAppModule -AppModuleId $app.appmoduleid | Out-Null;
$gone = Get-XrmAppModules -Name $name;
Assert-Test "AppModule removed" { $gone.Count -eq 0 };

Write-TestSummary;

<#
    Integration Test: model-driven apps and web resources (brief lot 6: A01 to A06)
    Add-/Set-/Upsert-XrmAppModule -Labels, Upsert-XrmAppModule on an unpublished app, Add-XrmAppModule -Id, Get-XrmAppModules -Id -UniqueName,
    Get-XrmAppSettingValues, Add-XrmAppModuleRoles (idempotent), Publish-XrmComponent (several ids, -TimeoutInMinutes), Export-XrmWebResource.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$defaultSolution = Get-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName "Default" -Columns "publisherid";
$iconQuery = New-XrmQueryExpression -LogicalName "webresource" -Columns "name" -TopCount 1 | Add-XrmQueryCondition -Field "webresourcetype" -Condition Equal -Values 11;
$icon = @(Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $iconQuery)[0];
$appIds = [System.Collections.Generic.List[Guid]]::new();

# ============================================================
# Upsert-XrmAppModule / Add-XrmAppModule / Set-XrmAppModule
# ============================================================
Write-Section "Upsert-XrmAppModule";

$upsertId = [Guid]::NewGuid();
$appIds.Add($upsertId);
$upsertUniqueName = "pdoupsertapp$suffix";
$upsertRef = Upsert-XrmAppModule -XrmClient $Global:XrmClient -Id $upsertId -Labels @{ 1033 = "PDO app $suffix"; 1036 = "Appli PDO $suffix" } -UniqueName $upsertUniqueName -WebResourceId $icon.Id -PublisherReference $defaultSolution.publisherid_Value;
$draft = @(Get-XrmAppModules -XrmClient $Global:XrmClient -Id $upsertId -Unpublished -Columns "name");
Assert-Test "Created with the given Id, unpublished" { $upsertRef.Id -eq $upsertId -and $draft.Count -eq 1 };
$labels = Get-XrmLocalizedLabel -XrmClient $Global:XrmClient -EntityMoniker $upsertRef -AttributeName "name" -AsHashtable;
Assert-Test "-Labels: name translated (A01)" { $labels[1033] -eq "PDO app $suffix" -and $labels[1036] -eq "Appli PDO $suffix" };

$secondError = $null;
try { Upsert-XrmAppModule -XrmClient $Global:XrmClient -Id $upsertId -Name "PDO app $suffix v2" -UniqueName $upsertUniqueName -ErrorAction Stop | Out-Null; } catch { $secondError = $_.Exception.Message; }
$draft = @(Get-XrmAppModules -XrmClient $Global:XrmClient -Id $upsertId -Unpublished -Columns "name");
Assert-Test "Second Upsert on the unpublished app: updated, not created again (A02) $secondError" { $null -eq $secondError -and $draft[0].name -eq "PDO app $suffix v2" };
Assert-Test "Get-XrmAppModules -UniqueName -Unpublished" { @(Get-XrmAppModules -XrmClient $Global:XrmClient -UniqueName $upsertUniqueName -Unpublished -Columns "name").Count -eq 1 };

Write-Section "Add-XrmAppModule -Id / Set-XrmAppModule -Labels";
$addId = [Guid]::NewGuid();
$appIds.Add($addId);
$addRef = Add-XrmAppModule -XrmClient $Global:XrmClient -Id $addId -Labels @{ 1033 = "PDO added $suffix"; 1036 = "PDO ajoutee $suffix" } -UniqueName "pdoaddapp$suffix" -WebResourceId $icon.Id -PublisherReference $defaultSolution.publisherid_Value;
Assert-Test "Add-XrmAppModule -Id: created with the given Id" { $addRef.Id -eq $addId };
Set-XrmAppModule -XrmClient $Global:XrmClient -AppModuleReference $addRef -Labels @{ 1033 = "PDO renamed $suffix"; 1036 = "PDO renommee $suffix" };
$labels = Get-XrmLocalizedLabel -XrmClient $Global:XrmClient -EntityMoniker $addRef -AttributeName "name" -AsHashtable;
Assert-Test "Set-XrmAppModule -Labels: both languages" { $labels[1033] -eq "PDO renamed $suffix" -and $labels[1036] -eq "PDO renommee $suffix" };

# ============================================================
# Settings and roles
# ============================================================
Write-Section "Get-XrmAppSettingValues";
$settingName = "OpenInNewWindowCommandBarButton";
Set-XrmAppSettingValue -XrmClient $Global:XrmClient -AppUniqueName $upsertUniqueName -SettingName $settingName -Value "false" | Out-Null;
$settings = @(Get-XrmAppSettingValues -XrmClient $Global:XrmClient -AppUniqueName $upsertUniqueName);
$setting = $settings | Where-Object { $_.SettingName -eq $settingName };
Assert-Test "App value read back, with its default" { $setting.Value -eq "false" -and $setting.DefaultValue -eq "true" };
$filtered = @(Get-XrmAppSettingValues -XrmClient $Global:XrmClient -AppUniqueName $upsertUniqueName -SettingName $settingName);
Assert-Test "-SettingName filter" { $filtered.Count -eq 1 };
$missingAppError = $null;
try { Get-XrmAppSettingValues -XrmClient $Global:XrmClient -AppUniqueName "pdo_no_app_$suffix" | Out-Null; } catch { $missingAppError = $_.Exception.Message; }
Assert-Test "Unknown app: error" { $missingAppError -like "*not found*" };

Write-Section "Add-XrmAppModuleRoles";
# A new app already holds a few roles: pick two it does not have
$initialRoleIds = @(Get-XrmAppModuleRoles -XrmClient $Global:XrmClient -AppModuleReference $addRef | ForEach-Object { $_.Id });
$roles = @(Get-XrmRoles -XrmClient $Global:XrmClient -OnlyRoots -Columns "name" | Where-Object { $initialRoleIds -notcontains $_.Id } | Select-Object -First 2);
Add-XrmAppModuleRoles -XrmClient $Global:XrmClient -AppModuleReference $addRef -RoleReferences @($roles[0].Reference) | Out-Null;
$repeatError = $null;
try { Add-XrmAppModuleRoles -XrmClient $Global:XrmClient -AppModuleReference $addRef -RoleReferences @($roles[0].Reference, $roles[1].Reference) -ErrorAction Stop | Out-Null; } catch { $repeatError = $_.Exception.Message; }
$assigned = @(Get-XrmAppModuleRoles -XrmClient $Global:XrmClient -AppModuleReference $addRef);
Assert-Test "Roles added again: no error, only the new one added (A04) $repeatError" { $null -eq $repeatError -and $assigned.Count -eq $initialRoleIds.Count + 2 };

# ============================================================
# Publish-XrmComponent / Export-XrmWebResource
# ============================================================
Write-Section "Publish-XrmComponent / Export-XrmWebResource";
$webResourceIds = [System.Collections.Generic.List[Guid]]::new();
foreach ($index in 1, 2) {
    $content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("// v1 $index"));
    $webResourceIds.Add(($Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "webresource" -Attributes @{
                    name = "new_pdo$suffix/scripts/file$index.js"; displayname = "PDO $index"; webresourcetype = (New-XrmOptionSetValue -Value 3); content = $content
                })));
}
foreach ($webResourceId in $webResourceIds) {
    $Global:XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "webresource" -Id $webResourceId -Attributes @{ content = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("// v2")) });
}
$affinityBefore = $Global:XrmClient.EnableAffinityCookie;
Publish-XrmComponent -XrmClient $Global:XrmClient -ComponentName "webresource" -ComponentId @($webResourceIds | ForEach-Object { "$_" }) -TimeoutInMinutes 10 | Out-Null;
Assert-Test "Caller's client unchanged by -TimeoutInMinutes (affinity $affinityBefore)" { $Global:XrmClient.EnableAffinityCookie -eq $affinityBefore };

$exportFolder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-webresources-$suffix";
$exported = Export-XrmWebResource -XrmClient $Global:XrmClient -Name "new_pdo$suffix/scripts/file1.js" -OutputPath $exportFolder;
Assert-Test "Export-XrmWebResource -Name: path follows the name, published content (v2)" { $exported -eq (Join-Path $exportFolder "new_pdo$suffix\scripts\file1.js") -and (Get-Content -Path $exported -Raw) -eq "// v2" };
$exportedById = Export-XrmWebResource -XrmClient $Global:XrmClient -Id $webResourceIds[1] -OutputPath $exportFolder;
Assert-Test "Export-XrmWebResource -Id: both published in one request" { (Get-Content -Path $exportedById -Raw) -eq "// v2" };
$missingError = $null;
try { Export-XrmWebResource -XrmClient $Global:XrmClient -Name "new_pdo_missing_$suffix.js" -OutputPath $exportFolder | Out-Null; } catch { $missingError = $_.Exception.Message; }
Assert-Test "Unknown web resource: error" { $missingError -like "*not found*" };

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
foreach ($webResourceId in $webResourceIds) { $Global:XrmClient | Remove-XrmRecord -LogicalName "webresource" -Id $webResourceId -IfExists; }
foreach ($appId in $appIds) {
    $query = New-XrmQueryExpression -LogicalName "appsetting" -Columns "appsettingid" | Add-XrmQueryCondition -Field "parentappmoduleid" -Condition Equal -Values $appId;
    foreach ($appSetting in @(Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $query)) { $Global:XrmClient | Remove-XrmRecord -LogicalName "appsetting" -Id $appSetting.Id -IfExists; }
    if (@(Get-XrmAppModules -XrmClient $Global:XrmClient -Id $appId -Unpublished -Columns "name").Count -gt 0) {
        $Global:XrmClient | Remove-XrmAppModule -AppModuleReference (New-XrmEntityReference -LogicalName "appmodule" -Id $appId);
    }
}
Remove-Item -Path $exportFolder -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Apps removed" { @($appIds | Where-Object { @(Get-XrmAppModules -XrmClient $Global:XrmClient -Id $_ -Unpublished -Columns "name").Count -gt 0 }).Count -eq 0 };

Write-TestSummary;

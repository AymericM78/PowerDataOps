<#!
    Integration Test: AppComponent cmdlets
    Validates add / get / remove app module components, before publishing (Get-XrmAppComponents -Unpublished) and after.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;

Write-Section "Create App Module and SiteMap";
$iconQuery = New-XrmQueryExpression -LogicalName "webresource" -Columns "name" -TopCount 1;
$iconQuery = $iconQuery | Add-XrmQueryCondition -Field "webresourcetype" -Condition Equal -Values 11;
$icon = $Global:XrmClient | Get-XrmMultipleRecords -Query $iconQuery | Select-Object -First 1;
$defaultSolution = $Global:XrmClient | Get-XrmSolution -SolutionUniqueName "Default" -Columns "publisherid";

$appRef = $Global:XrmClient | Add-XrmAppModule -Name "PDO App Components $suffix" -UniqueName "pdoappcomp$suffix" -WebResourceId $icon.Id -PublisherReference $defaultSolution.publisherid_Value;
Assert-Test "AppModule created" { $null -ne $appRef -and $appRef.Id -ne [Guid]::Empty };

$siteMapRef = $Global:XrmClient | Add-XrmSiteMap -Name "PDO App Components $suffix" -SiteMapXml '<SiteMap><Area Id="A1"><Group Id="G1"><SubArea Id="S1" Entity="account" /></Group></Area></SiteMap>';
Assert-Test "SiteMap created" { $null -ne $siteMapRef };

$view = @($Global:XrmClient | Get-XrmViews -EntityLogicalName "account" -Columns "name")[0];

Write-Section "Add components to the unpublished app";
$components = @(
    (New-XrmEntityReference -LogicalName "sitemap" -Id $siteMapRef.Id),
    (New-XrmEntityReference -LogicalName "savedquery" -Id $view.Id)
);
$Global:XrmClient | Add-XrmAppComponents -AppModuleId $appRef.Id -Components $components | Out-Null;

$unpublishedComponents = $Global:XrmClient | Get-XrmAppComponents -AppModuleId $appRef.Id -Unpublished;
$unpublishedTypes = @($unpublishedComponents.Entities | ForEach-Object { $_["componenttype"].Value });
Assert-Test "-Unpublished returns an EntityCollection" { $unpublishedComponents -is [Microsoft.Xrm.Sdk.EntityCollection] };
Assert-Test "-Unpublished returns the sitemap (62) and the view (26) before publishing" {
    $unpublishedTypes -contains 62 -and $unpublishedTypes -contains 26;
};

$publishedError = $null;
try {
    $Global:XrmClient | Get-XrmAppComponents -AppModuleId $appRef.Id -ErrorAction Stop | Out-Null;
}
catch {
    $publishedError = $_.Exception.Message;
}
Assert-Test "Without -Unpublished, RetrieveAppComponents fails on a never published app" { $null -ne $publishedError };

Write-Section "Publish";
$Global:XrmClient | Publish-XrmComponent -ComponentName "appmodule" -ComponentId $appRef.Id | Out-Null;
$publishedComponents = $Global:XrmClient | Get-XrmAppComponents -AppModuleId $appRef.Id;
$publishedTypes = @($publishedComponents.Entities | ForEach-Object { $_["componenttype"].Value });
Assert-Test "After publish, RetrieveAppComponents returns the sitemap and the view" {
    $publishedTypes -contains 62 -and $publishedTypes -contains 26;
};

Write-Section "Remove Component";
$Global:XrmClient | Remove-XrmAppComponents -AppModuleId $appRef.Id -Components @((New-XrmEntityReference -LogicalName "savedquery" -Id $view.Id)) | Out-Null;
$afterRemove = $Global:XrmClient | Get-XrmAppComponents -AppModuleId $appRef.Id -Unpublished;
$afterRemoveTypes = @($afterRemove.Entities | ForEach-Object { $_["componenttype"].Value });
Assert-Test "Component removed (view gone, sitemap kept)" {
    $afterRemoveTypes -notcontains 26 -and $afterRemoveTypes -contains 62;
};

Write-Section "Cleanup";
$cleanupErrors = [System.Collections.Generic.List[string]]::new();
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "appmodule" -Id $appRef.Id -ErrorAction Stop; } catch { $cleanupErrors.Add("app: $($_.Exception.Message)"); }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "sitemap" -Id $siteMapRef.Id -ErrorAction Stop; } catch { $cleanupErrors.Add("sitemap: $($_.Exception.Message)"); }
Assert-Test "Cleanup complete (app and sitemap deleted) $($cleanupErrors -join ' | ')" {
    $cleanupErrors.Count -eq 0 -and @(Get-XrmAppModules -XrmClient $Global:XrmClient -Id $appRef.Id -Unpublished -Columns "name").Count -eq 0;
};
Write-TestSummary;

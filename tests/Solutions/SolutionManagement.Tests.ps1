<#
    Integration Test: solution and publisher management (brief lot 4: S02 to S07, S09 to S11)
    Upsert-XrmPublisher, Get-XrmPublisher -Prefix, Get-XrmPublishers, Upsert-XrmSolution, Get-XrmSolutions -PublisherId -VisibleOnly,
    Test-XrmSolution -Managed / -Unmanaged, Test-XrmSolutionComponent, Move-XrmSolutionComponent, Get-XrmSolutionComponents -IfExists,
    Export-XrmSolution -Unpack, Export-XrmTranslations, Get-XrmLocalizedLabel, Uninstall-XrmSolution -OnlyIfEmpty -IfExists (alias Remove-XrmSolution),
    Remove-XrmRecord -IfExists.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$letters = -join ((1..3) | ForEach-Object { [char](Get-Random -Minimum 97 -Maximum 123) });
$prefix = "pdm$letters";
$publisherUniqueName = "pdomgmt$suffix";
$sourceUniqueName = "pdomgmtsrc$suffix";
$targetUniqueName = "pdomgmttgt$suffix";
$exportFolder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-export-$suffix";
New-Item -ItemType Directory -Path $exportFolder | Out-Null;

# ============================================================
# Publisher
# ============================================================
Write-Section "Upsert-XrmPublisher / Get-XrmPublisher -Prefix / Get-XrmPublishers";

$missingError = $null;
try { Upsert-XrmPublisher -XrmClient $Global:XrmClient -UniqueName $publisherUniqueName -DisplayName "x" | Out-Null; } catch { $missingError = $_.Exception.Message; }
Assert-Test "Creation without Prefix: actionable error" { $missingError -like "*Prefix*required*" };

$publisherRef = Upsert-XrmPublisher -XrmClient $Global:XrmClient -UniqueName $publisherUniqueName -DisplayNameLabels @{ 1033 = "PDO publisher $suffix"; 1036 = "Editeur PDO $suffix" } -Prefix $prefix -OptionValuePrefix (10000 + ($suffix % 89999)) -Description "Integration test publisher";
$publisher = Get-XrmPublisher -XrmClient $Global:XrmClient -PublisherUniqueName $publisherUniqueName;
Assert-Test "Created: display name from the base language, prefix set" { $publisherRef.Id -eq $publisher.Id -and $publisher.friendlyname -eq "PDO publisher $suffix" -and $publisher.customizationprefix -eq $prefix };

$publisherLabels = Get-XrmLocalizedLabel -XrmClient $Global:XrmClient -EntityMoniker $publisherRef -AttributeName "friendlyname" -AsHashtable;
Assert-Test "Get-XrmLocalizedLabel -AsHashtable: French display name" { $publisherLabels[1036] -eq "Editeur PDO $suffix" };

$sameRef = Upsert-XrmPublisher -XrmClient $Global:XrmClient -UniqueName $publisherUniqueName -DisplayName "PDO publisher $suffix (updated)";
Assert-Test "Second call updates the display name" { $sameRef.Id -eq $publisherRef.Id -and (Get-XrmPublisher -XrmClient $Global:XrmClient -PublisherUniqueName $publisherUniqueName).friendlyname -eq "PDO publisher $suffix (updated)" };

$byPrefix = @(Get-XrmPublisher -XrmClient $Global:XrmClient -Prefix $prefix);
Assert-Test "Get-XrmPublisher -Prefix: found" { $byPrefix.Count -eq 1 -and $byPrefix[0].Id -eq $publisherRef.Id };

$customPublishers = @(Get-XrmPublishers -XrmClient $Global:XrmClient -CustomOnly);
Assert-Test "Get-XrmPublishers -CustomOnly: includes it, no read-only publisher" { @($customPublishers | Where-Object { $_.Id -eq $publisherRef.Id }).Count -eq 1 -and @($customPublishers | Where-Object { $_ | Get-XrmRowValue -Name "isreadonly" }).Count -eq 0 };

# ============================================================
# Solutions
# ============================================================
Write-Section "Upsert-XrmSolution / Get-XrmSolutions / Test-XrmSolution";

$sourceRef = Upsert-XrmSolution -XrmClient $Global:XrmClient -UniqueName $sourceUniqueName -DisplayNameLabels @{ 1033 = "PDO source $suffix"; 1036 = "Source PDO $suffix" } -PublisherUniqueName $publisherUniqueName -Version "1.0.0.0";
$targetRef = Upsert-XrmSolution -XrmClient $Global:XrmClient -UniqueName $targetUniqueName -DisplayName "PDO target $suffix" -PublisherReference $publisherRef;
Assert-Test "Two solutions created" { $null -ne $sourceRef -and $null -ne $targetRef -and $sourceRef.Id -ne $targetRef.Id };

Upsert-XrmSolution -XrmClient $Global:XrmClient -UniqueName $sourceUniqueName -Version "1.1.0.0" | Out-Null;
$source = Get-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName -Columns "version", "friendlyname";
Assert-Test "Version updated, display name kept" { $source.version -eq "1.1.0.0" -and $source.friendlyname -eq "PDO source $suffix" };
$sourceLabels = Get-XrmLocalizedLabel -XrmClient $Global:XrmClient -EntityMoniker $sourceRef -AttributeName "friendlyname" -AsHashtable;
Assert-Test "Solution display name in French" { $sourceLabels[1036] -eq "Source PDO $suffix" };

$byPublisher = @(Get-XrmSolutions -XrmClient $Global:XrmClient -PublisherId $publisherRef.Id -VisibleOnly -Columns "uniquename");
Assert-Test "Get-XrmSolutions -PublisherId -VisibleOnly: the two test solutions" { $byPublisher.Count -eq 2 -and @($byPublisher | Where-Object { $_.uniquename -in $sourceUniqueName, $targetUniqueName }).Count -eq 2 };
Assert-Test "Get-XrmSolutions -VisibleOnly: no Active nor Basic" { @(Get-XrmSolutions -XrmClient $Global:XrmClient -VisibleOnly -Columns "uniquename" | Where-Object { $_.uniquename -in "Active", "Basic" }).Count -eq 0 };

Assert-Test "Test-XrmSolution -Unmanaged: true, -Managed: false" { (Test-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName -Unmanaged) -and -not (Test-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName -Managed) };
$managedSolution = @(Get-XrmSolutions -XrmClient $Global:XrmClient -VisibleOnly -Columns "uniquename", "ismanaged" | Where-Object { $_ | Get-XrmRowValue -Name "ismanaged" }) | Select-Object -First 1;
if ($managedSolution) {
    Assert-Test "Test-XrmSolution -Managed on '$($managedSolution.uniquename)': true" { Test-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $managedSolution.uniquename -Managed };
}
$managedError = $null;
if ($managedSolution) {
    try { Upsert-XrmSolution -XrmClient $Global:XrmClient -UniqueName $managedSolution.uniquename -Version "9.9.9.9" -WhatIf | Out-Null; } catch { $managedError = $_.Exception.Message; }
    Assert-Test "Upsert-XrmSolution on a managed solution: refused" { $managedError -like "*is managed*" };
}

# ============================================================
# Components
# ============================================================
Write-Section "Test-XrmSolutionComponent / Move-XrmSolutionComponent";

$definitionRef = Upsert-XrmEnvironmentVariableDefinition -XrmClient $Global:XrmClient -SchemaName "$($prefix)_movetest$suffix" -DisplayName "PDO move test" -DefaultValue "x" -SolutionUniqueName $sourceUniqueName;
$definitionType = Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "environmentvariabledefinition";
Assert-Test "Test-XrmSolutionComponent: in source, not in target" {
    (Test-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType) -and
    -not (Test-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType);
};

$moved = Move-XrmSolutionComponent -XrmClient $Global:XrmClient -From $sourceUniqueName -To $targetUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType;
Assert-Test "Move-XrmSolutionComponent: now in target only" {
    $moved.TargetSolutionUniqueName -eq $targetUniqueName -and
    (Test-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType) -and
    -not (Test-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType);
};

$moveError = $null;
try { Move-XrmSolutionComponent -XrmClient $Global:XrmClient -From $sourceUniqueName -To $targetUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType | Out-Null; } catch { $moveError = $_.Exception.Message; }
Assert-Test "Move from a solution without the component: error" { $moveError -like "*is not in solution*" };

$solutionError = $null;
try { Test-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName "pdo_missing_$suffix" -ComponentId $definitionRef.Id -ComponentType $definitionType | Out-Null; } catch { $solutionError = $_.Exception.Message; }
Assert-Test "Test-XrmSolutionComponent on a missing solution: error" { $solutionError -like "*not found*" };

$missingComponents = Get-XrmSolutionComponents -XrmClient $Global:XrmClient -SolutionUniqueName "pdo_missing_$suffix" -IfExists -ErrorVariable componentErrors;
Assert-Test "Get-XrmSolutionComponents -IfExists on a missing solution: `$null, no error" { $null -eq $missingComponents -and $componentErrors.Count -eq 0 };

# ============================================================
# Exports
# ============================================================
Write-Section "Export-XrmSolution -Unpack / Export-XrmTranslations";

$unpacked = Export-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ExportPath $exportFolder -Unpack;
Assert-Test "Export-XrmSolution -Unpack: folder with solution.xml and customizations.xml" { (Test-Path (Join-Path $unpacked "solution.xml")) -and (Test-Path (Join-Path $unpacked "customizations.xml")) -and (Test-Path (Join-Path $exportFolder "$targetUniqueName.zip")) };

$customFolder = Join-Path $exportFolder "custom";
$unpackedCustom = Export-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ExportPath $exportFolder -Unpack -UnpackPath $customFolder;
Assert-Test "-UnpackPath: extracted where asked" { $unpackedCustom -eq $customFolder -and (Test-Path (Join-Path $customFolder "solution.xml")) };

$translationsZip = Export-XrmTranslations -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ExportPath $exportFolder;
Assert-Test "Export-XrmTranslations: zip written" { (Test-Path $translationsZip) -and $translationsZip -like "*CrmTranslations_$targetUniqueName.zip" };
$translationsFolder = Export-XrmTranslations -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ExportPath $exportFolder -Unpack;
Assert-Test "Export-XrmTranslations -Unpack: CrmTranslations.xml" { Test-Path (Join-Path $translationsFolder "CrmTranslations.xml") };

# ============================================================
# Idempotent cleanup
# ============================================================
Write-Section "Uninstall-XrmSolution -OnlyIfEmpty -IfExists / Remove-XrmRecord -IfExists";

Remove-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -OnlyIfEmpty;
Assert-Test "-OnlyIfEmpty on a solution with a component: kept" { Test-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName };

Remove-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -ComponentId $definitionRef.Id -ComponentType $definitionType | Out-Null;
Remove-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -OnlyIfEmpty;
Assert-Test "-OnlyIfEmpty on an empty solution: removed (alias Remove-XrmSolution)" { -not (Test-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName) };

$ifExistsErrors = $null;
Uninstall-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -IfExists -ErrorVariable ifExistsErrors;
Assert-Test "-IfExists on a missing solution: no error" { $ifExistsErrors.Count -eq 0 };

$Global:XrmClient | Remove-XrmRecord -LogicalName "environmentvariabledefinition" -Id $definitionRef.Id;
$removeFailure = $null;
try { $removeOutput = @($Global:XrmClient | Remove-XrmRecord -LogicalName "environmentvariabledefinition" -Id $definitionRef.Id -IfExists -ErrorAction Stop 2>&1); } catch { $removeFailure = $_.Exception.Message; }
Assert-Test "Remove-XrmRecord -IfExists on a deleted row: no error, even with -ErrorAction Stop" { $null -eq $removeFailure -and @($removeOutput | Where-Object { $_ -is [System.Management.Automation.ErrorRecord] }).Count -eq 0 };
$plainError = $null;
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "environmentvariabledefinition" -Id $definitionRef.Id -ErrorAction Stop; } catch { $plainError = $_.Exception.Message; }
Assert-Test "Remove-XrmRecord without -IfExists on a deleted row: error, as before" { $plainError -like "*Does Not Exist*" };

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
Uninstall-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName -IfExists;
Uninstall-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetUniqueName -IfExists;
$Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id -IfExists;
Remove-Item -Path $exportFolder -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Cleanup complete" { -not (Test-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $sourceUniqueName) -and -not (Test-XrmPublisher -XrmClient $Global:XrmClient -PublisherUniqueName $publisherUniqueName) };

Write-TestSummary;

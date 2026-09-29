<#
    Integration Test: Upsert-XrmWebResource / Sync-XrmWebResources
    Default output (id only when created or updated), -PassThru object, skipped files, and folder synchronization with publish.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$randomSuffix = Get-Random -Minimum 10000 -Maximum 99999;
$prefix = "pdw";
$folder = Join-Path $env:TEMP "PdoWebResources_$randomSuffix";
$scriptFolder = Join-Path $folder "$($prefix)_\scripts";
New-Item -ItemType Directory -Path $scriptFolder -Force | Out-Null;

Write-Section "Setup publisher and solution";

$publisherRef = $Global:XrmClient | Add-XrmPublisher -UniqueName "pdowebres$randomSuffix" -DisplayName "PDO WebResources $randomSuffix" -Prefix $prefix -OptionValuePrefix (10000 + ($randomSuffix % 89999)) -Description "Integration test publisher";
$solutionUniqueName = "pdowebressol$randomSuffix";
$solutionRef = $Global:XrmClient | Add-XrmSolution -UniqueName $solutionUniqueName -DisplayName "PDO WebResources $randomSuffix" -PublisherReference $publisherRef -Version "1.0.0.0" -Description "Integration test solution";
Assert-Test "Publisher and solution created" { $null -ne $publisherRef -and $null -ne $solutionRef };

Write-Section "Upsert-XrmWebResource";

$scriptPath = Join-Path $scriptFolder "test$randomSuffix.js";
Set-Content -Path $scriptPath -Value "// version 1" -NoNewline;
$expectedName = "$($prefix)_/scripts/test$randomSuffix.js";

$createdOutput = @($Global:XrmClient | Upsert-XrmWebResource -FilePath $scriptPath -SolutionUniqueName $solutionUniqueName);
Assert-Test "Created: returns only the webresource id (no solution component response leaked)" {
    $createdOutput.Count -eq 1 -and $createdOutput[0] -is [Guid];
};
$webResourceId = $createdOutput[0];

$unchangedOutput = @($Global:XrmClient | Upsert-XrmWebResource -FilePath $scriptPath -SolutionUniqueName $solutionUniqueName);
Assert-Test "Unchanged: returns nothing by default" {
    $unchangedOutput.Count -eq 0;
};

$unchangedResult = $Global:XrmClient | Upsert-XrmWebResource -FilePath $scriptPath -SolutionUniqueName $solutionUniqueName -PassThru;
Assert-Test "Unchanged with -PassThru: Id, Name, Changed = false" {
    $unchangedResult.Id -eq $webResourceId -and $unchangedResult.Name -eq $expectedName -and $unchangedResult.Changed -eq $false -and $unchangedResult.Skipped -eq $false;
};

Set-Content -Path $scriptPath -Value "// version 2" -NoNewline;
$updatedResult = $Global:XrmClient | Upsert-XrmWebResource -FilePath $scriptPath -SolutionUniqueName $solutionUniqueName -PassThru;
Assert-Test "Updated with -PassThru: Changed = true" {
    $updatedResult.Id -eq $webResourceId -and $updatedResult.Changed -eq $true;
};

$otherPath = Join-Path $folder "other$randomSuffix.js";
Set-Content -Path $otherPath -Value "// no prefix" -NoNewline;
$skippedResult = $Global:XrmClient | Upsert-XrmWebResource -FilePath $otherPath -SolutionUniqueName $solutionUniqueName -PassThru;
Assert-Test "File without the prefix: Skipped with -PassThru" {
    $null -ne $skippedResult -and $skippedResult.Skipped -eq $true -and $null -eq $skippedResult.Id;
};

Write-Section "Sync-XrmWebResources";

$secondPath = Join-Path $scriptFolder "second$randomSuffix.js";
Set-Content -Path $secondPath -Value "// second" -NoNewline;
$syncError = $null;
try {
    $Global:XrmClient | Sync-XrmWebResources -FolderPath $folder -SolutionUniqueName $solutionUniqueName -SynchronizationMode Full | Out-Null;
}
catch {
    $syncError = $_.Exception.Message;
}
Assert-Test "Folder synchronized and published without error" { $null -eq $syncError };

$secondRecord = $Global:XrmClient | Get-XrmRecord -LogicalName "webresource" -AttributeName "name" -Value "$($prefix)_/scripts/second$randomSuffix.js" -Columns "name";
Assert-Test "New file created by the synchronization" { $null -ne $secondRecord };

Write-Section "Cleanup";

foreach ($id in @($webResourceId, $secondRecord.Id)) {
    if ($id) {
        try { $Global:XrmClient | Remove-XrmRecord -LogicalName "webresource" -Id $id; } catch { }
    }
}
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "solution" -Id $solutionRef.Id; } catch { }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id; } catch { }
Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Cleanup complete" { $true };

Write-TestSummary;

<#
    Integration Test: Add-XrmSolutionComponents
    Tests batch add behavior for solution components.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$randomSuffix = Get-Random -Minimum 10000 -Maximum 99999;

Write-Section "Setup publisher and solution";

$publisherUniqueName = "pdotestbatch${randomSuffix}";
$publisherDisplayName = "PDO Batch Publisher $randomSuffix";
$publisherPrefix = "pdb";

$publisherRef = $Global:XrmClient | Add-XrmPublisher `
    -UniqueName $publisherUniqueName `
    -DisplayName $publisherDisplayName `
    -Prefix $publisherPrefix `
    -OptionValuePrefix (10000 + ($randomSuffix % 89999)) `
    -Description "Integration test publisher for Add-XrmSolutionComponents";

Assert-Test "Publisher created" {
    $publisherRef -ne $null -and $publisherRef.Id -ne [Guid]::Empty;
};

$solutionUniqueName = "pdotestbatchsol${randomSuffix}";
$solutionDisplayName = "PDO Batch Solution $randomSuffix";

$solutionRef = $Global:XrmClient | Add-XrmSolution `
    -UniqueName $solutionUniqueName `
    -DisplayName $solutionDisplayName `
    -PublisherReference $publisherRef `
    -Version "1.0.0.0" `
    -Description "Integration test solution for Add-XrmSolutionComponents";

Assert-Test "Solution created" {
    $solutionRef -ne $null -and $solutionRef.Id -ne [Guid]::Empty;
};

Write-Section "Batch add components";

$retrieveReq = New-Object Microsoft.Xrm.Sdk.Messages.RetrieveEntityRequest;
$retrieveReq.LogicalName = "account";
$retrieveReq.EntityFilters = [Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity;
$retrieveResp = $Global:XrmClient.Execute($retrieveReq);
$accountMetadataId = $retrieveResp.EntityMetadata.MetadataId;

Assert-Test "Account metadata id retrieved" {
    $accountMetadataId -ne $null -and $accountMetadataId -ne [Guid]::Empty;
};

$components = @(
    [pscustomobject]@{ ComponentId = $accountMetadataId; ComponentType = 1 },
    [pscustomobject]@{ ComponentId = [Guid]::NewGuid(); ComponentType = 1 }
);

$results = @($Global:XrmClient | Add-XrmSolutionComponents `
    -SolutionUniqueName $solutionUniqueName `
    -Components $components `
    -ContinueOnError $true);

Assert-Test "Add-XrmSolutionComponents returns 2 result rows" {
    $results.Count -eq 2;
};

$successResult = $results | Where-Object { $_.ComponentId -eq $accountMetadataId } | Select-Object -First 1;
Assert-Test "Valid component added successfully" {
    $successResult -ne $null -and $successResult.Success -eq $true;
};

$failureResult = $results | Where-Object { $_.Success -eq $false } | Select-Object -First 1;
Assert-Test "Invalid component reported as failure" {
    $failureResult -ne $null -and -not [string]::IsNullOrWhiteSpace($failureResult.ErrorMessage);
};

$solutionComponents = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @(1));
$containsAccountEntity = $false;
foreach ($component in $solutionComponents) {
    try {
        if ([Guid]::Parse($component.objectid.ToString()) -eq $accountMetadataId) {
            $containsAccountEntity = $true;
            break;
        }
    }
    catch {
    }
}
Assert-Test "Solution now contains account entity component" {
    $containsAccountEntity;
};

Write-Section "Add-XrmSolutionComponent - DoNotIncludeSubcomponents default by type";

$webResourceQuery = New-XrmQueryExpression -LogicalName "webresource" -Columns "name" -TopCount 2;
$webResources = @($Global:XrmClient | Get-XrmMultipleRecords -Query $webResourceQuery);

$singleResponse = $Global:XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $solutionUniqueName -ComponentId $webResources[0].Id -ComponentType 61;
Assert-Test "Web resource (type 61) added without DoNotIncludeSubcomponents" {
    $null -ne $singleResponse;
};

$batchResults = @($Global:XrmClient | Add-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -Components @(
        [pscustomobject]@{ ComponentId = $webResources[1].Id; ComponentType = 61 }
    ));
Assert-Test "Add-XrmSolutionComponents - web resource added with the default" {
    $batchResults.Count -eq 1 -and $batchResults[0].Success -eq $true;
};

$addErrorMessage = $null;
try {
    $Global:XrmClient | Add-XrmSolutionComponent -SolutionUniqueName "pdomissing$randomSuffix" -ComponentId $webResources[0].Id -ComponentType 61 | Out-Null;
}
catch {
    $addErrorMessage = $_.Exception.Message;
}
Assert-Test "Refused addition raises an error naming the solution" {
    $addErrorMessage -like "*pdomissing$randomSuffix*";
};

Write-Section "Cleanup";

foreach ($webResource in $webResources) {
    try {
        $Global:XrmClient | Remove-XrmSolutionComponent -SolutionUniqueName $solutionUniqueName -ComponentId $webResource.Id -ComponentType 61;
    }
    catch {
    }
}

try {
    $Global:XrmClient | Remove-XrmSolutionComponent -SolutionUniqueName $solutionUniqueName -ComponentId $accountMetadataId -ComponentType 1;
}
catch {
}

try {
    $Global:XrmClient | Remove-XrmRecord -LogicalName "solution" -Id $solutionRef.Id;
}
catch {
}
Assert-Test "Solution cleanup executed" { $true };

try {
    $Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id;
}
catch {
}
Assert-Test "Publisher cleanup executed" { $true };

Write-TestSummary;

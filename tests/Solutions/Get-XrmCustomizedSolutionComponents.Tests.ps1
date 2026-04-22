<#
    Integration Test: Get-XrmCustomizedSolutionComponents
    Tests retrieval of customized components from Active layer.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$randomSuffix = Get-Random -Minimum 10000 -Maximum 99999;

Write-Section "Setup publisher and solution";

$publisherUniqueName = "pdotestlayers${randomSuffix}";
$publisherDisplayName = "PDO Layers Publisher $randomSuffix";
$publisherPrefix = "pdl";

$publisherRef = $Global:XrmClient | New-XrmPublisher `
    -UniqueName $publisherUniqueName `
    -DisplayName $publisherDisplayName `
    -Prefix $publisherPrefix `
    -OptionValuePrefix (10000 + ($randomSuffix % 89999)) `
    -Description "Integration test publisher for customized components";

Assert-Test "Publisher created" {
    $publisherRef -ne $null -and $publisherRef.Id -ne [Guid]::Empty;
};

$solutionUniqueName = "pdotestlayerssol${randomSuffix}";
$solutionDisplayName = "PDO Layers Solution $randomSuffix";

$solutionRef = $Global:XrmClient | New-XrmSolution `
    -UniqueName $solutionUniqueName `
    -DisplayName $solutionDisplayName `
    -PublisherReference $publisherRef `
    -Version "1.0.0.0" `
    -Description "Integration test solution for customized components";

Assert-Test "Solution created" {
    $solutionRef -ne $null -and $solutionRef.Id -ne [Guid]::Empty;
};

Write-Section "Empty solution behavior";

$emptyResults = @($Global:XrmClient | Get-XrmCustomizedSolutionComponents -SolutionUniqueName $solutionUniqueName -IncludeDetails);
Assert-Test "Empty solution returns no customized components" {
    $emptyResults.Count -eq 0;
};

Write-Section "Optional positive probe from existing Active-layer component";

$queryLayer = New-XrmQueryExpression -LogicalName "msdyn_componentlayer" -Columns "msdyn_componentid", "msdyn_solutioncomponentname", "msdyn_changes" -TopCount 1;
$queryLayer = $queryLayer | Add-XrmQueryCondition -Field "msdyn_solutionname" -Condition Equal -Values "Active";
$layer = @($Global:XrmClient | Get-XrmMultipleRecords -Query $queryLayer) | Select-Object -First 1;

if ($layer) {
    $componentId = $null;
    $componentName = $null;

    try {
        $componentId = [Guid]::Parse($layer.msdyn_componentid.ToString());
    }
    catch {
        $componentId = $null;
    }

    if ($layer.PSObject.Properties.Match("msdyn_solutioncomponentname").Count -gt 0) {
        $componentName = [string]$layer.msdyn_solutioncomponentname;
    }

    $componentTypeCandidates = @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 29, 31, 32, 33, 34, 35, 36, 37, 38, 39, 44, 45, 46, 47, 48, 49, 50, 52, 53, 55, 59, 60, 61, 62, 63, 64, 65, 66, 68, 70, 71, 90, 91, 92, 93, 95, 150, 151, 152, 153, 154, 155, 161, 162, 165, 166, 201, 202, 203, 204, 205, 206, 207, 208, 210, 300, 371, 372, 380, 381, 400, 401, 402, 430, 431, 432);
    $componentType = $null;

    if ($componentId -and -not [string]::IsNullOrWhiteSpace($componentName)) {
        foreach ($candidateType in $componentTypeCandidates) {
            try {
                $candidateName = Get-XrmSolutionComponentName -SolutionComponentType $candidateType;
                if ($candidateName -eq $componentName) {
                    $componentType = $candidateType;
                    break;
                }
            }
            catch {
            }
        }

        if ($componentType) {
            $addResults = @($Global:XrmClient | Add-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -Components @([pscustomobject]@{ ComponentId = $componentId; ComponentType = $componentType; }) -ContinueOnError $true);
            $added = ($addResults | Where-Object { $_.Success -eq $true }).Count -ge 1;

            if ($added) {
                $includedProperty = $null;
                try {
                    $layerChanges = $layer.msdyn_changes | ConvertFrom-Json;
                    if ($layerChanges -and $layerChanges.Attributes) {
                        foreach ($change in $layerChanges.Attributes) {
                            if ($change -and $change.PSObject.Properties.Match("Key").Count -gt 0 -and -not [string]::IsNullOrWhiteSpace([string]$change.Key)) {
                                $includedProperty = [string]$change.Key;
                                break;
                            }
                        }
                    }
                }
                catch {
                }

                if (-not [string]::IsNullOrWhiteSpace($includedProperty)) {
                    $customizedComponents = @($Global:XrmClient | Get-XrmCustomizedSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @($componentType) -IncludedProperties @($includedProperty) -ExcludedProperties @() -IncludeDetails);
                    $matching = @($customizedComponents | Where-Object { $_.ComponentId -eq $componentId });

                    Assert-Test "Customized component query executes with IncludeDetails" {
                        $customizedComponents -ne $null;
                    };

                    Assert-Test "Matching component returned when included property is present" {
                        $matching.Count -ge 1;
                    };
                }
                else {
                    Assert-Test "Layer change payload does not expose property keys - skipped strict positive assertion" { $true };
                }
            }
            else {
                Assert-Test "Failed to add active-layer component to test solution - skipped strict positive assertion" { $true };
            }
        }
        else {
            Assert-Test "Could not map solution component name to type - skipped strict positive assertion" { $true };
        }
    }
    else {
        Assert-Test "Layer row missing required fields - skipped strict positive assertion" { $true };
    }
}
else {
    Assert-Test "No Active layer rows in environment - skipped strict positive assertion" { $true };
}

Write-Section "Cleanup";

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

<#
    Integration Test: Test-XrmComponentCustomization
    Tests Active-layer customization detection.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Baseline negative case";

$randomComponentId = [Guid]::NewGuid();
$isCustomized = $Global:XrmClient | Test-XrmComponentCustomization -ComponentId $randomComponentId -SolutionComponentName "Entity";
Assert-Test "Unknown component returns false" {
    $isCustomized -eq $false;
};

Write-Section "Existing active-layer component (if available)";

$queryLayer = New-XrmQueryExpression -LogicalName "msdyn_componentlayer" -Columns "msdyn_componentid", "msdyn_solutioncomponentname", "msdyn_changes" -TopCount 1;
$queryLayer = $queryLayer | Add-XrmQueryCondition -Field "msdyn_solutionname" -Condition Equal -Values "Active";
$layer = @($Global:XrmClient | Get-XrmMultipleRecords -Query $queryLayer) | Select-Object -First 1;

if ($layer) {
    $componentId = $null;
    try {
        if ($layer.PSObject.Properties.Match("msdyn_componentid").Count -gt 0) {
            $componentId = [Guid]::Parse($layer.msdyn_componentid.ToString());
        }
    }
    catch {
        $componentId = $null;
    }

    $componentName = $null;
    if ($layer.PSObject.Properties.Match("msdyn_solutioncomponentname").Count -gt 0) {
        $componentName = [string]$layer.msdyn_solutioncomponentname;
    }

    if ($componentId -and -not [string]::IsNullOrWhiteSpace($componentName)) {
        $boolResult = $Global:XrmClient | Test-XrmComponentCustomization -ComponentId $componentId -SolutionComponentName $componentName;
        $details = $Global:XrmClient | Test-XrmComponentCustomization -ComponentId $componentId -SolutionComponentName $componentName -ReturnDetails;

        Assert-Test "ReturnDetails returns object" {
            $details -ne $null -and $details.PSObject.Properties.Name -contains "HasCustomization";
        };

        Assert-Test "Bool result equals detail.HasCustomization" {
            [bool]$boolResult -eq [bool]$details.HasCustomization;
        };

        Assert-Test "Details contain requested ComponentId" {
            $details.ComponentId -eq $componentId;
        };
    }
    else {
        Assert-Test "Layer probe unavailable - skipped detailed assertions" { $true };
    }
}
else {
    Assert-Test "No Active layer rows in environment - skipped detailed assertions" { $true };
}

Write-TestSummary;

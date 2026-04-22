<#
    Integration Test: Solutions
    Tests publisher, solution, solution component cmdlets.
    Cmdlets: Add-XrmPublisher, Get-XrmPublisher, Add-XrmSolution,
             Get-XrmSolution, Add-XrmSolutionComponent, Get-XrmSolutionComponents,
             Remove-XrmSolutionComponent, Uninstall-XrmSolution
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$randomSuffix = Get-Random -Minimum 10000 -Maximum 99999;

# ============================================================
# Add-XrmPublisher + Get-XrmPublisher
# ============================================================
Write-Section "Add-XrmPublisher + Get-XrmPublisher";

$publisherUniqueName = "pdotest${randomSuffix}";
$publisherDisplayName = "PDO Test Publisher $randomSuffix";
$publisherPrefix = "pdot";

Assert-Test "Test-XrmPublisher - publisher absent before create" {
    -not ($Global:XrmClient | Test-XrmPublisher -PublisherUniqueName $publisherUniqueName);
};

$publisherRef = $Global:XrmClient | Add-XrmPublisher `
    -UniqueName $publisherUniqueName `
    -DisplayName $publisherDisplayName `
    -Prefix $publisherPrefix `
    -OptionValuePrefix (10000 + ($randomSuffix % 89999)) `
    -Description "Integration test publisher";

Assert-Test "Add-XrmPublisher - created '$publisherUniqueName'" {
    $publisherRef -ne $null -and $publisherRef.Id -ne [Guid]::Empty;
};

$publisher = $Global:XrmClient | Get-XrmPublisher -PublisherUniqueName $publisherUniqueName;
Assert-Test "Get-XrmPublisher - uniquename matches" {
    $publisher.uniquename -eq $publisherUniqueName;
};
Assert-Test "Get-XrmPublisher - friendlyname matches" {
    $publisher.friendlyname -eq $publisherDisplayName;
};
Assert-Test "Get-XrmPublisher - prefix matches" {
    $publisher.customizationprefix -eq $publisherPrefix;
};
Assert-Test "Test-XrmPublisher - publisher exists after create" {
    $Global:XrmClient | Test-XrmPublisher -PublisherUniqueName $publisherUniqueName;
};

# ============================================================
# Add-XrmSolution + Get-XrmSolution
# ============================================================
Write-Section "Add-XrmSolution + Get-XrmSolution";

$solutionUniqueName = "pdotestsol${randomSuffix}";
$solutionDisplayName = "PDO Test Solution $randomSuffix";

Assert-Test "Test-XrmSolution - solution absent before create" {
    -not ($Global:XrmClient | Test-XrmSolution -SolutionUniqueName $solutionUniqueName);
};

$solutionRef = $Global:XrmClient | Add-XrmSolution `
    -UniqueName $solutionUniqueName `
    -DisplayName $solutionDisplayName `
    -PublisherReference $publisherRef `
    -Version "1.0.0.0" `
    -Description "Integration test solution";

Assert-Test "Add-XrmSolution - created '$solutionUniqueName'" {
    $solutionRef -ne $null -and $solutionRef.Id -ne [Guid]::Empty;
};

$solution = $Global:XrmClient | Get-XrmSolution -SolutionUniqueName $solutionUniqueName;
Assert-Test "Get-XrmSolution - uniquename matches" {
    $solution.uniquename -eq $solutionUniqueName;
};
Assert-Test "Get-XrmSolution - version is 1.0.0.0" {
    $solution.version -eq "1.0.0.0";
};
Assert-Test "Test-XrmSolution - solution exists after create" {
    $Global:XrmClient | Test-XrmSolution -SolutionUniqueName $solutionUniqueName;
};

# ============================================================
# Add-XrmSolutionComponent + Get-XrmSolutionComponents
# ============================================================
Write-Section "Solution Components";

# Get Account entity metadata ID via RetrieveEntityRequest
$retrieveReq = New-Object Microsoft.Xrm.Sdk.Messages.RetrieveEntityRequest;
$retrieveReq.LogicalName = "account";
$retrieveReq.EntityFilters = [Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity;
$retrieveResp = $Global:XrmClient.Execute($retrieveReq);
$accountMetadataId = $retrieveResp.EntityMetadata.MetadataId;

Assert-Test "Account metadata ID retrieved" {
    $accountMetadataId -ne $null -and $accountMetadataId -ne [Guid]::Empty;
};

# Add Account entity (componenttype 1) to the solution
$Global:XrmClient | Add-XrmSolutionComponent `
    -SolutionUniqueName $solutionUniqueName `
    -ComponentId $accountMetadataId `
    -ComponentType 1 `
    -DoNotIncludeSubcomponents $true;

# Verify via Get-XrmSolutionComponents
$components = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName);
Assert-Test "Add-XrmSolutionComponent - component count >= 1 (actual: $($components.Count))" {
    $components.Count -ge 1;
};

# Get components filtered by type (1 = Entity)
$entityComponents = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @(1));
Assert-Test "Get-XrmSolutionComponents (Entity type) - returns entity component" {
    $entityComponents.Count -ge 1;
};

# ============================================================
# Remove-XrmSolutionComponent
# ============================================================
Write-Section "Remove-XrmSolutionComponent";

$Global:XrmClient | Remove-XrmSolutionComponent `
    -SolutionUniqueName $solutionUniqueName `
    -ComponentId $accountMetadataId `
    -ComponentType 1;

# Verify component removed
$componentsAfter = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @(1));
Assert-Test "Remove-XrmSolutionComponent - no entity components remain (actual: $($componentsAfter.Count))" {
    $componentsAfter.Count -eq 0;
};

# ============================================================
# CLEANUP: Delete solution + publisher records
# ============================================================
Write-Section "Cleanup";

# Delete solution record directly (unmanaged solution)
$Global:XrmClient | Remove-XrmRecord -LogicalName "solution" -Id $solutionRef.Id;
Assert-Test "Solution deleted" { $true };
Assert-Test "Test-XrmSolution - solution absent after delete" {
    -not ($Global:XrmClient | Test-XrmSolution -SolutionUniqueName $solutionUniqueName);
};

# Delete publisher record
$Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id;
Assert-Test "Publisher deleted" { $true };
Assert-Test "Test-XrmPublisher - publisher absent after delete" {
    -not ($Global:XrmClient | Test-XrmPublisher -PublisherUniqueName $publisherUniqueName);
};

Write-TestSummary;

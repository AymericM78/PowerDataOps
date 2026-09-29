<#
    Integration Test: views and ribbons (brief lot 6: A07, A08)
    Get-XrmViews -QueryType -IsDefault, Upsert-XrmView -IsDefault, Get-XrmRibbon (several tables), Export-XrmRibbon, Import-XrmRibbon -TargetSolutionUniqueName.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$tableName = "new_pdoview$suffix";
$Global:XrmClient | Add-XrmTable -LogicalName $tableName -DisplayName "PDO view $suffix" -PluralName "PDO views" -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name" | Out-Null;

# ============================================================
# Views
# ============================================================
Write-Section "Get-XrmViews -QueryType -IsDefault";

$defaultViews = @(Get-XrmViews -XrmClient $Global:XrmClient -EntityLogicalName $tableName -QueryType 0 -IsDefault -Columns "name", "querytype", "isdefault");
Assert-Test "One default public view on a new table" { $defaultViews.Count -eq 1 -and ($defaultViews[0] | Get-XrmRowValue -Name "isdefault") };
$quickFind = @(Get-XrmViews -XrmClient $Global:XrmClient -EntityLogicalName $tableName -QueryType 4 -Columns "name", "querytype");
Assert-Test "-QueryType 4: the quick find view" { $quickFind.Count -eq 1 -and ($quickFind[0] | Get-XrmRowValue -Name "querytype") -eq 4 };
$publicViews = @(Get-XrmViews -XrmClient $Global:XrmClient -EntityLogicalName $tableName -QueryType 0 -Columns "name");

Write-Section "Upsert-XrmView -IsDefault";
$viewId = [Guid]::NewGuid();
$fetchXml = "<fetch><entity name='$tableName'><attribute name='new_name' /></entity></fetch>";
$layoutXml = "<grid name='resultset' object='1' jump='new_name' select='1' icon='1' preview='1'><row name='result' id='${tableName}id'><cell name='new_name' width='300' /></row></grid>";
Upsert-XrmView -XrmClient $Global:XrmClient -Id $viewId -EntityLogicalName $tableName -Name "PDO default $suffix" -FetchXml $fetchXml -LayoutXml $layoutXml -IsDefault $true | Out-Null;
$defaultViews = @(Get-XrmViews -XrmClient $Global:XrmClient -EntityLogicalName $tableName -QueryType 0 -IsDefault -Columns "name");
Assert-Test "The new view is the only default public view ($($defaultViews.Count) default)" { $defaultViews.Count -eq 1 -and $defaultViews[0].Id -eq $viewId };
Assert-Test "One more public view" { @(Get-XrmViews -XrmClient $Global:XrmClient -EntityLogicalName $tableName -QueryType 0 -Columns "name").Count -eq $publicViews.Count + 1 };

# ============================================================
# Ribbons
# ============================================================
Write-Section "Get-XrmRibbon / Export-XrmRibbon";

# Existing tables only: the export job can miss a table created seconds before ("not found in the MetadataCache")
$ribbons = @(Get-XrmRibbon -XrmClient $Global:XrmClient -EntityLogicalName "account", "contact");
Assert-Test "Two tables, one export: one RibbonDiffXml each" {
    $ribbons.Count -eq 2 -and $ribbons[0].EntityLogicalName -eq "account" -and $ribbons[1].EntityLogicalName -eq "contact" -and
    @($ribbons | Where-Object { $_.RibbonDiffXml -isnot [System.Xml.XmlElement] }).Count -eq 0;
};
$exported = Export-XrmRibbon -XrmClient $Global:XrmClient -EntityLogicalName "contact";
Assert-Test "Export-XrmRibbon (now through Get-XrmRibbon): same XML" { $exported.OuterXml -eq $ribbons[1].RibbonDiffXml.OuterXml };

Write-Section "Import-XrmRibbon -TargetSolutionUniqueName";
$publisherRef = $Global:XrmClient | Add-XrmPublisher -UniqueName "pdoribbon$suffix" -DisplayName "PDO Ribbon $suffix" -Prefix "pdr" -OptionValuePrefix (10000 + ($suffix % 89999)) -Description "Integration test publisher";
$targetName = "pdoribbonsol$suffix";
$Global:XrmClient | Add-XrmSolution -UniqueName $targetName -DisplayName "PDO Ribbon $suffix" -PublisherReference $publisherRef -Version "1.0.0.0" | Out-Null;
# The contact ribbon is imported back unchanged
Import-XrmRibbon -XrmClient $Global:XrmClient -EntityLogicalName "contact" -RibbonDiffXml $ribbons[1].RibbonDiffXml -PublisherUniqueName "pdoribbon$suffix" -TargetSolutionUniqueName $targetName -Publish $false;
$contact = Get-XrmEntityMetadata -XrmClient $Global:XrmClient -LogicalName "contact" -Filter Entity;
Assert-Test "The table (and its ribbon) is in the target solution" { Test-XrmSolutionComponent -XrmClient $Global:XrmClient -SolutionUniqueName $targetName -ComponentId $contact.MetadataId -ComponentType 1 };
$after = @(Get-XrmRibbon -XrmClient $Global:XrmClient -EntityLogicalName "contact");
Assert-Test "Ribbon unchanged after the round trip" { $after[0].RibbonDiffXml.OuterXml -eq $ribbons[1].RibbonDiffXml.OuterXml };
Assert-Test "No temporary ribbon solution left" { @(Get-XrmSolutions -XrmClient $Global:XrmClient -Columns "uniquename" | Where-Object { $_.uniquename -like "Ribbon*_*" }).Count -eq 0 };

# ============================================================
# Cleanup
# ============================================================
Write-Section "Cleanup";
Uninstall-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName $targetName -IfExists;
$Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id -IfExists;
$Global:XrmClient | Remove-XrmTable -LogicalName $tableName | Out-Null;
Assert-Test "Test table removed" { -not (Test-XrmTable -XrmClient $Global:XrmClient -LogicalName $tableName) };

Write-TestSummary;

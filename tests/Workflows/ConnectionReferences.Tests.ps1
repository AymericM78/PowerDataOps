<#
    Integration Test: connection references (brief W04)
    Upsert-XrmConnectionReference, Get-XrmConnectionReferences, Set-XrmConnectionReference.
    The test instance has no connection: the binding success path cannot run, only the platform check of the connection id.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$logicalName = "pdc_pdotestref$suffix";

Write-Section "Setup publisher and solution";
$publisherRef = $Global:XrmClient | Add-XrmPublisher -UniqueName "pdoconnref$suffix" -DisplayName "PDO ConnRef $suffix" -Prefix "pdc" -OptionValuePrefix (10000 + ($suffix % 89999)) -Description "Integration test publisher";
$solutionUniqueName = "pdoconnrefsol$suffix";
$solutionRef = $Global:XrmClient | Add-XrmSolution -UniqueName $solutionUniqueName -DisplayName "PDO ConnRef $suffix" -PublisherReference $publisherRef -Version "1.0.0.0" -Description "Integration test solution";

Write-Section "Upsert-XrmConnectionReference";
$missingConnectorError = $null;
try { $Global:XrmClient | Upsert-XrmConnectionReference -LogicalName $logicalName | Out-Null; } catch { $missingConnectorError = $_.Exception.Message; }
Assert-Test "Creation without -ConnectorId raises an actionable error" { $missingConnectorError -like "*ConnectorId*" };

$referenceRef = $Global:XrmClient | Upsert-XrmConnectionReference -LogicalName $logicalName -DisplayName "PDO test reference" -ConnectorId "shared_commondataserviceforapps" -SolutionUniqueName $solutionUniqueName;
Assert-Test "Created with a short connector id" { $null -ne $referenceRef -and $referenceRef.LogicalName -eq "connectionreference" };

$updatedRef = $Global:XrmClient | Upsert-XrmConnectionReference -LogicalName $logicalName -DisplayName "PDO test reference (renamed)";
Assert-Test "Second call updates the same row" { $updatedRef.Id -eq $referenceRef.Id };

Write-Section "Get-XrmConnectionReferences";
$byName = @($Global:XrmClient | Get-XrmConnectionReferences -LogicalName $logicalName);
Assert-Test "-LogicalName: found, display name updated, full connector id stored" {
    $byName.Count -eq 1 -and $byName[0].connectionreferencedisplayname -eq "PDO test reference (renamed)" -and $byName[0].connectorid -eq "/providers/Microsoft.PowerApps/apis/shared_commondataserviceforapps";
};
$byConnector = @($Global:XrmClient | Get-XrmConnectionReferences -ConnectorId "shared_commondataserviceforapps");
Assert-Test "-ConnectorId (short form): includes the new reference" { @($byConnector | Where-Object { $_.Id -eq $referenceRef.Id }).Count -eq 1 };

$componentType = Get-XrmSolutionComponentType -XrmClient $Global:XrmClient -LogicalName "connectionreference";
$components = @($Global:XrmClient | Get-XrmSolutionComponents -SolutionUniqueName $solutionUniqueName -ComponentTypes @($componentType));
Assert-Test "-SolutionUniqueName: added to the solution (component type $componentType)" { @($components | Where-Object { [Guid]$_.objectid -eq $referenceRef.Id }).Count -eq 1 };

Write-Section "Set-XrmConnectionReference";
$bindError = $null;
try { $Global:XrmClient | Set-XrmConnectionReference -LogicalName $logicalName -ConnectionId "pdo-no-such-connection" -ErrorAction Stop | Out-Null; } catch { $bindError = $_.Exception.Message; }
Assert-Test "Unknown connection: the platform check is surfaced" { $bindError -like "*pdo-no-such-connection*" };

$notFoundError = $null;
try { $Global:XrmClient | Set-XrmConnectionReference -LogicalName "pdc_missing$suffix" -ConnectionId "x" | Out-Null; } catch { $notFoundError = $_.Exception.Message; }
Assert-Test "Unknown connection reference: error" { $notFoundError -like "*pdc_missing$suffix*not found*" };

Write-Section "Cleanup";
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "connectionreference" -Id $referenceRef.Id; } catch { }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "solution" -Id $solutionRef.Id; } catch { }
try { $Global:XrmClient | Remove-XrmRecord -LogicalName "publisher" -Id $publisherRef.Id; } catch { }
Assert-Test "Cleanup complete" { $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "connectionreference" -Id $referenceRef.Id -IfExists) };

Write-TestSummary;

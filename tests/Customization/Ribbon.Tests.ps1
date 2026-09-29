<#!
    Integration Test: Ribbon cmdlets
    Validates export and import of ribbon via solution manipulation (temporary solution on the default publisher).
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

function Get-TempRibbonSolutionCount {
    $query = New-XrmQueryExpression -LogicalName "solution" -Columns "uniquename";
    $query.Criteria.FilterOperator = [Microsoft.Xrm.Sdk.Query.LogicalOperator]::Or;
    $query = $query | Add-XrmQueryCondition -Field "uniquename" -Condition BeginsWith -Values "RibbonExport_";
    $query = $query | Add-XrmQueryCondition -Field "uniquename" -Condition BeginsWith -Values "RibbonImport_";
    return @($Global:XrmClient | Get-XrmMultipleRecords -Query $query).Count;
}

$entity = "account";
$tempSolutionsBefore = Get-TempRibbonSolutionCount;

Write-Section "Export Ribbon";
$ribbon = $Global:XrmClient | Export-XrmRibbon -EntityLogicalName $entity;
Assert-Test "RibbonDiffXml exported without a publisher argument" { $ribbon -and $ribbon.OuterXml -like '*RibbonDiffXml*' };

Write-Section "Import Ribbon (round trip with the exported XmlElement)";
$Global:XrmClient | Import-XrmRibbon -EntityLogicalName $entity -RibbonDiffXml $ribbon -Publish $false | Out-Null;
$ribbonAfter = $Global:XrmClient | Export-XrmRibbon -EntityLogicalName $entity;
Assert-Test "Ribbon unchanged after importing the exported XmlElement" {
    $ribbonAfter -and $ribbonAfter.OuterXml -eq $ribbon.OuterXml;
};

Write-Section "Failures";
$errorMessage = $null;
try {
    $Global:XrmClient | Export-XrmRibbon -EntityLogicalName $entity -PublisherUniqueName "pdo_missing_publisher" | Out-Null;
}
catch {
    $errorMessage = $_.Exception.Message;
}
Assert-Test "Unknown publisher raises the original error" {
    $errorMessage -like "*pdo_missing_publisher*";
};

Write-Section "Cleanup";
Assert-Test "No temporary ribbon solution left behind" {
    (Get-TempRibbonSolutionCount) -eq $tempSolutionsBefore;
};

Write-TestSummary;

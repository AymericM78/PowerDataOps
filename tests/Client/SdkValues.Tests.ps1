<#
    Integration Test: SDK value normalization
    Values wrapped in a PowerShell PSObject (New-Object, pipeline output) or passed as Object[] are normalized
    before they reach the SDK, so requests serialize.
    Cmdlets: Set-XrmAttributeValue (through New-XrmEntity), Add-XrmRequestParameter, Add-XrmQueryCondition,
             Add-XrmQueryLinkCondition, Add-XrmBulkDelete
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Attributes
# ============================================================
Write-Section "Attributes: PSObject-wrapped values";

$name = Get-TestName -Prefix "SdkValue";
$pipedName = $name | ForEach-Object { $_ };
$creditLimit = New-Object Microsoft.Xrm.Sdk.Money 1500;
$record = New-XrmEntity -LogicalName "account" -Attributes @{
    "name"        = $pipedName;
    "creditlimit" = $creditLimit;
};
$record.Id = $Global:XrmClient | Add-XrmRecord -Record $record;
Assert-Test "Account created from a piped string and a New-Object Money (Id = $($record.Id))" {
    $null -ne $record.Id -and $record.Id -ne [Guid]::Empty;
};

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $record.Id -Columns "name", "creditlimit";
Assert-Test "Values persisted" {
    $check.name -eq $name -and $check.creditlimit_Value.Value -eq 1500;
};

# ============================================================
# Query conditions
# ============================================================
Write-Section "Add-XrmQueryCondition / Add-XrmQueryLinkCondition";

$pipedId = $record.Id | ForEach-Object { $_ };
$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values @($pipedId);
$rows = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "In with a piped Guid returns the record" {
    $rows.Count -eq 1 -and $rows[0].Id -eq $record.Id;
};

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name" -TopCount 5;
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values @();
$rows = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "Empty In returns no row" {
    $rows.Count -eq 0;
};

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query.Criteria.FilterOperator = [Microsoft.Xrm.Sdk.Query.LogicalOperator]::Or;
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values @();
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition Equal -Values $record.Id;
$rows = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "Empty In under an Or filter does not widen the result" {
    $rows.Count -eq 1 -and $rows[0].Id -eq $record.Id;
};

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition Equal -Values $record.Id;
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition NotIn -Values @();
$rows = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "Empty NotIn adds no restriction" {
    $rows.Count -eq 1;
};

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition Equal -Values $record.Id;
$link = $query | Add-XrmQueryLink -ToEntityName "systemuser" -FromAttributeName "owninguser" -ToAttributeName "systemuserid";
$link | Add-XrmQueryLinkCondition -Field "isdisabled" -Condition Equal -Values @($false) | Out-Null;
Assert-Test "Link condition keeps a falsy value (@(`$false))" {
    $link.LinkCriteria.Conditions[0].Values.Count -eq 1 -and $link.LinkCriteria.Conditions[0].Values[0] -eq $false;
};
$rows = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "Query with the link condition returns the record" {
    $rows.Count -eq 1;
};

# ============================================================
# Request parameters
# ============================================================
Write-Section "Add-XrmRequestParameter";

$request = New-XrmRequest -Name "Retrieve";
$target = New-Object Microsoft.Xrm.Sdk.EntityReference -ArgumentList "account", $record.Id;
$columnSet = New-Object Microsoft.Xrm.Sdk.Query.ColumnSet -ArgumentList (, [string[]]@("name"));
$request | Add-XrmRequestParameter -Name "Target" -Value $target | Out-Null;
$request | Add-XrmRequestParameter -Name "ColumnSet" -Value $columnSet | Out-Null;
$response = $Global:XrmClient | Invoke-XrmRequest -Request $request;
Assert-Test "Retrieve built from New-Object values succeeds" {
    $null -ne $response -and $response.Results["Entity"]["name"] -eq $name;
};

$typedRequest = New-XrmRequest -Name "Test";
$typedRequest | Add-XrmRequestParameter -Name "Ids" -Value @($record.Id, [Guid]::NewGuid()) | Out-Null;
Assert-Test "Homogeneous Object[] is typed (Guid[])" {
    $typedRequest.Parameters["Ids"] -is [Guid[]];
};

$errorMessage = $null;
try {
    $typedRequest | Add-XrmRequestParameter -Name "Bad" -Value ([PSCustomObject]@{ Id = 1 }) | Out-Null;
}
catch {
    $errorMessage = $_.Exception.Message;
}
Assert-Test "PSCustomObject value raises an error that names the parameter" {
    $errorMessage -like "*'Bad'*";
};

# ============================================================
# Add-XrmBulkDelete
# ============================================================
Write-Section "Add-XrmBulkDelete";

$bulkQuery = New-XrmQueryExpression -LogicalName "account" -Columns "accountid";
$bulkQuery = $bulkQuery | Add-XrmQueryCondition -Field "name" -Condition Equal -Values "$name-none";
$bulkResponse = $Global:XrmClient | Add-XrmBulkDelete -Query $bulkQuery -JobName "PowerDataOps test $name";
Assert-Test "BulkDelete accepted: QuerySet sent as QueryExpression[] (JobId returned)" {
    $null -ne $bulkResponse -and $bulkResponse.Results["JobId"] -ne [Guid]::Empty;
};

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $record.Id;
Assert-Test "Cleanup complete" { $true };

Write-TestSummary;

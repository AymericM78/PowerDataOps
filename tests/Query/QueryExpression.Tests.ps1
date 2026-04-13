<#
    Integration Test: Query Expression
    Tests query building and execution cmdlets.
    Cmdlets: New-XrmQueryExpression, Add-XrmQueryCondition, Add-XrmQueryLink,
             Add-XrmQueryLinkCondition, Add-XrmQueryOrder, Get-XrmMultipleRecords,
             Get-XrmTotalRecordCount
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# SETUP - create test data
# ============================================================
Write-Section "Setup - create test accounts";

$testPrefix = "QryTest_$(Get-Date -Format 'yyyyMMddHHmmss')";
$ids = @();

for ($i = 1; $i -le 3; $i++) {
    $record = New-XrmEntity -LogicalName "account" -Attributes @{
        "name"        = "$($testPrefix)_$i";
        "description" = "Query integration test";
        "revenue"     = New-XrmMoney -Value ($i * 10000);
    };
    $record.Id = $Global:XrmClient | Add-XrmRecord -Record $record;
    $ids += $record.Id;
}
Assert-Test "Created 3 test accounts" { $ids.Count -eq 3 };

# ============================================================
# New-XrmQueryExpression
# ============================================================
Write-Section "New-XrmQueryExpression";

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name", "revenue";
Assert-Test "Query created for account" {
    $query.EntityName -eq "account";
};

# ============================================================
# Add-XrmQueryCondition - Equal
# ============================================================
Write-Section "Add-XrmQueryCondition";

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "name" -Condition Equal -Values @("$($testPrefix)_1");
$results = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "Condition Equal - returns 1 record" {
    $results.Count -eq 1 -and $results[0].name -eq "$($testPrefix)_1";
};

# BeginsWith
$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values @($testPrefix);
$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "Condition BeginsWith - returns 3 records (actual: $($results.Count))" {
    $results.Count -eq 3;
};

# In
$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values $ids;
$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "Condition In (3 Ids) - returns 3 records" {
    $results.Count -eq 3;
};

# ============================================================
# Add-XrmQueryOrder
# ============================================================
Write-Section "Add-XrmQueryOrder";

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values @($testPrefix);
$query = $query | Add-XrmQueryOrder -Field "name" -OrderType Ascending;
$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "Order Ascending - first = _1, last = _3" {
    $results[0].name -eq "$($testPrefix)_1" -and $results[-1].name -eq "$($testPrefix)_3";
};

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values @($testPrefix);
$query = $query | Add-XrmQueryOrder -Field "name" -OrderType Descending;
$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "Order Descending - first = _3, last = _1" {
    $results[0].name -eq "$($testPrefix)_3" -and $results[-1].name -eq "$($testPrefix)_1";
};

# ============================================================
# Add-XrmQueryLink + Add-XrmQueryLinkCondition
# ============================================================
Write-Section "Add-XrmQueryLink + Add-XrmQueryLinkCondition";

# Create a contact linked to account 1
$contact = New-XrmEntity -LogicalName "contact" -Attributes @{
    "firstname" = "LinkTest";
    "lastname"  = $testPrefix;
    "parentcustomerid" = New-XrmEntityReference -LogicalName "account" -Id $ids[0];
};
$contact.Id = $Global:XrmClient | Add-XrmRecord -Record $contact;
Assert-Test "Contact created for link test (Id = $($contact.Id))" {
    $contact.Id -ne [Guid]::Empty;
};

# Query contacts linked to our test account
$query = New-XrmQueryExpression -LogicalName "contact" -Columns "firstname", "lastname";
$link = $query | Add-XrmQueryLink -FromAttributeName "parentcustomerid" -ToEntityName "account" -ToAttributeName "accountid";
$link | Add-XrmQueryLinkCondition -Field "accountid" -Condition Equal -Values @($ids[0]) | Out-Null;
$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
$found = $results | Where-Object { $_.lastname -eq $testPrefix };
Assert-Test "Link query - found contact linked to account 1" {
    $found -ne $null;
};

# ============================================================
# TopCount
# ============================================================
Write-Section "TopCount";

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name" -TopCount 2;
$query = $query | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values @($testPrefix);
$query = $query | Add-XrmQueryOrder -Field "name" -OrderType Ascending;
$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "TopCount 2 - returns max 2 records (actual: $($results.Count))" {
    $results.Count -eq 2;
};

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmRecord -LogicalName "contact" -Id $contact.Id;
foreach ($id in $ids) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $id;
}

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values $ids;
$remaining = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
$count = if ($remaining) { $remaining.Count } else { 0 };
Assert-Test "All test records deleted (remaining: $count)" { $count -eq 0 };

Write-TestSummary;

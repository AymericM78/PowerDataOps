<#
    Integration Test: Account CRUD
    Creates accounts, retrieves them, updates them, changes state, deletes them.
    Each step verifies the result via a retrieve before moving on.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# CREATE
# ============================================================
Write-Section "Create accounts";

# Account 1 - simple
$account1Name = Get-TestName -Prefix "Account";
$account1 = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = $account1Name;
};
$account1.Id = $Global:XrmClient | Add-XrmRecord -Record $account1;
Assert-Test "Account 1 created (Id = $($account1.Id))" {
    $account1.Id -ne [Guid]::Empty;
};

# Retrieve to verify
$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account1.Id -Columns "name";
Assert-Test "Account 1 retrieve - name matches" {
    $check -ne $null -and $check.name -eq $account1Name;
};

# Account 2 - with revenue
$account2Name = Get-TestName -Prefix "Account";
$account2 = New-XrmEntity -LogicalName "account" -Attributes @{
    "name"    = $account2Name;
    "revenue" = New-XrmMoney -Value 50000;
};
$account2.Id = $Global:XrmClient | Add-XrmRecord -Record $account2;
Assert-Test "Account 2 created (Id = $($account2.Id))" {
    $account2.Id -ne [Guid]::Empty;
};

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account2.Id -Columns "name", "revenue";
Assert-Test "Account 2 retrieve - name matches and revenue = 50000" {
    $check.name -eq $account2Name -and $check.revenue_Value.Value -eq 50000;
};

# Account 3 - for state change tests
$account3Name = Get-TestName -Prefix "Account";
$account3 = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = $account3Name;
};
$account3.Id = $Global:XrmClient | Add-XrmRecord -Record $account3;
Assert-Test "Account 3 created (Id = $($account3.Id))" {
    $account3.Id -ne [Guid]::Empty;
};

# ============================================================
# READ - Query multiple
# ============================================================
Write-Section "Read accounts (query)";

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values @($account1.Id, $account2.Id, $account3.Id);
$accounts = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "Query returns 3 accounts (actual: $($accounts.Count))" {
    $accounts.Count -eq 3;
};

# Read by attribute value
$byName = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -AttributeName "name" -Value $account2Name -Columns "name", "revenue";
Assert-Test "Get-XrmRecord by name found with revenue = 50000" {
    $byName -ne $null -and $byName.revenue_Value.Value -eq 50000;
};

# ============================================================
# UPDATE
# ============================================================
Write-Section "Update accounts";

# Update account 1 name
$updatedName = "$($account1Name)_Updated";
$updateRecord = New-XrmEntity -LogicalName "account" -Id $account1.Id -Attributes @{
    "name" = $updatedName;
};
$Global:XrmClient | Update-XrmRecord -Record $updateRecord;

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account1.Id -Columns "name";
Assert-Test "Account 1 name updated to '$($check.name)'" {
    $check.name -eq $updatedName;
};

# Update account 2 revenue
$updateRecord = New-XrmEntity -LogicalName "account" -Id $account2.Id -Attributes @{
    "revenue" = New-XrmMoney -Value 75000;
};
$Global:XrmClient | Update-XrmRecord -Record $updateRecord;

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account2.Id -Columns "revenue";
Assert-Test "Account 2 revenue updated to 75000" {
    $check.revenue_Value.Value -eq 75000;
};

# ============================================================
# STATE CHANGE
# ============================================================
Write-Section "State changes (account 3)";

# Deactivate
$account3Ref = $account3.ToEntityReference();
$Global:XrmClient | Set-XrmRecordState -RecordReference $account3Ref -StateCode 1 -StatusCode 2;

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account3.Id -Columns "statecode", "statuscode";
Assert-Test "Account 3 deactivated - statecode = $($check.statecode_Value.Value)" {
    $check.statecode_Value.Value -eq 1;
};

# Reactivate
$Global:XrmClient | Set-XrmRecordState -RecordReference $account3Ref -StateCode 0 -StatusCode 1;

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account3.Id -Columns "statecode", "statuscode";
Assert-Test "Account 3 reactivated - statecode = $($check.statecode_Value.Value)" {
    $check.statecode_Value.Value -eq 0;
};

# ============================================================
# DELETE
# ============================================================
Write-Section "Delete accounts";

$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $account1.Id;
$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $account2.Id;
$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $account3.Id;

# Verify deletion
$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values @($account1.Id, $account2.Id, $account3.Id);
$remaining = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
$count = if ($remaining) { $remaining.Count } else { 0 };
Assert-Test "All 3 accounts deleted (remaining: $count)" {
    $count -eq 0;
};

# ============================================================
Write-TestSummary;

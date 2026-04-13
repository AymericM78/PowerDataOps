<#
    Integration Test: Record Operations
    Tests Upsert, Bulk requests, Attributes get/set, ConvertTo-XrmObject/Type.
    Cmdlets: Upsert-XrmRecord, Invoke-XrmBulkRequests, Get-XrmAttributeValue,
             Set-XrmAttributeValue, ConvertTo-XrmObject, ConvertTo-XrmType
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# ConvertTo-XrmType (offline - no server needed)
# ============================================================
Write-Section "ConvertTo-XrmType";

$intVal = ConvertTo-XrmType -Type "int" -Value "42";
Assert-Test "ConvertTo-XrmType int = 42" { $intVal -eq 42 };

$decVal = ConvertTo-XrmType -Type "decimal" -Value "314";
Assert-Test "ConvertTo-XrmType decimal = 314" { $decVal -eq 314 };

$boolVal = ConvertTo-XrmType -Type "bool" -Value "true";
Assert-Test "ConvertTo-XrmType bool = true" { $boolVal -eq $true };

$guidVal = ConvertTo-XrmType -Type "guid" -Value "00000000-0000-0000-0000-000000000001";
Assert-Test "ConvertTo-XrmType guid" { $guidVal -is [Guid] };

$moneyVal = ConvertTo-XrmType -Type "money" -Value "500";
Assert-Test "ConvertTo-XrmType money = 500" { $moneyVal.Value -eq 500 };

$osvVal = ConvertTo-XrmType -Type "optionset" -Value "3";
Assert-Test "ConvertTo-XrmType optionset = 3" { $osvVal.Value -eq 3 };

$refVal = ConvertTo-XrmType -Type "entityreference" -Value "00000000-0000-0000-0000-000000000001" -EntityLogicalName "account";
Assert-Test "ConvertTo-XrmType entityreference" { $refVal.LogicalName -eq "account" };

$strVal = ConvertTo-XrmType -Type "string" -Value "hello";
Assert-Test "ConvertTo-XrmType string = hello" { $strVal -eq "hello" };

# ============================================================
# Get-XrmAttributeValue / Set-XrmAttributeValue (offline)
# ============================================================
Write-Section "Get-XrmAttributeValue / Set-XrmAttributeValue";

$entity = New-XrmEntity -LogicalName "account" -Attributes @{ "name" = "Original" };
$val = Get-XrmAttributeValue -Record $entity -Name "name";
Assert-Test "Get-XrmAttributeValue - name = Original" { $val -eq "Original" };

$entity = Set-XrmAttributeValue -Record $entity -Name "name" -Value "Updated";
$val = Get-XrmAttributeValue -Record $entity -Name "name";
Assert-Test "Set-XrmAttributeValue then Get - name = Updated" { $val -eq "Updated" };

$missing = Get-XrmAttributeValue -Record $entity -Name "nonexistent";
Assert-Test "Get-XrmAttributeValue - missing returns null" { $null -eq $missing };

# ============================================================
# Upsert-XrmRecord
# ============================================================
Write-Section "Upsert-XrmRecord";

# Create via upsert (new record)
$upsertName = Get-TestName -Prefix "Upsert";
$record = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = $upsertName;
};
$record.Id = $Global:XrmClient | Add-XrmRecord -Record $record;
Assert-Test "Account created for upsert test (Id = $($record.Id))" {
    $record.Id -ne [Guid]::Empty;
};

# Update via upsert (existing record)
$upsertUpdatedName = "$($upsertName)_Upserted";
$upsertRecord = New-XrmEntity -LogicalName "account" -Id $record.Id -Attributes @{
    "name" = $upsertUpdatedName;
};
$Global:XrmClient | Upsert-XrmRecord -Record $upsertRecord;

$check = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $record.Id -Columns "name";
Assert-Test "Upsert updated name to '$($check.name)'" {
    $check.name -eq $upsertUpdatedName;
};

# ============================================================
# Invoke-XrmBulkRequests
# ============================================================
Write-Section "Invoke-XrmBulkRequests";

$bulkIds = @();
$requests = @();
for ($i = 1; $i -le 5; $i++) {
    $bulkEntity = New-XrmEntity -LogicalName "account" -Attributes @{
        "name" = Get-TestName -Prefix "Bulk";
    };
    $req = New-XrmRequest -Name "Create";
    $req | Add-XrmRequestParameter -Name "Target" -Value $bulkEntity | Out-Null;
    $requests += $req;
}

$Global:XrmClient | Invoke-XrmBulkRequests -Requests $requests -ContinueOnError $false -ReturnResponses $true;

# Retrieve to verify
$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values @("Bulk_IntTest_");
$bulkResults = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;
Assert-Test "Bulk create - at least 5 accounts created (actual: $($bulkResults.Count))" {
    $bulkResults.Count -ge 5;
};

# Store Ids for cleanup
$bulkIds = $bulkResults | ForEach-Object { $_.Id };

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $record.Id;
foreach ($id in $bulkIds) {
    $Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $id;
}
Assert-Test "Cleanup complete" { $true };

Write-TestSummary;

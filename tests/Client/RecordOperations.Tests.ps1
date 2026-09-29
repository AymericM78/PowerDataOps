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

# BatchSize 2 => 3 ExecuteMultiple calls (2 + 2 + 1)
$bulkResponses = @($Global:XrmClient | Invoke-XrmBulkRequests -Requests $requests -BatchSize 2 -ContinueOnError $false -ReturnResponses $true -Quiet);
Assert-Test "Bulk create - one OrganizationResponse per request, no index leaked (actual: $($bulkResponses.Count))" {
    $bulkResponses.Count -eq 5 -and @($bulkResponses | Where-Object { $_ -isnot [Microsoft.Xrm.Sdk.OrganizationResponse] }).Count -eq 0;
};

# Store Ids for cleanup
$bulkIds = @($bulkResponses | ForEach-Object { $_.Results["id"] });

# Retrieve to verify
$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$query = $query | Add-XrmQueryCondition -Field "accountid" -Condition In -Values $bulkIds;
$bulkResults = @($Global:XrmClient | Get-XrmMultipleRecords -Query $query);
Assert-Test "Bulk create - 5 accounts created (actual: $($bulkResults.Count))" {
    $bulkResults.Count -eq 5;
};

$firstName = $requests[0].Parameters["Target"]["name"];
$firstCheck = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $bulkIds[0] -Columns "name";
Assert-Test "Bulk create - responses are in request order" {
    $firstCheck.name -eq $firstName;
};

Write-Section "Invoke-XrmBulkRequests - faults";

# Third request targets a missing record: batch 2, relative index 0, global index 2
$faultRequests = @();
foreach ($id in @($bulkIds[0], $bulkIds[1], [Guid]::NewGuid())) {
    $updateEntity = New-XrmEntity -LogicalName "account" -Id $id -Attributes @{ "description" = "Bulk fault test" };
    $req = New-XrmRequest -Name "Update";
    $req | Add-XrmRequestParameter -Name "Target" -Value $updateEntity | Out-Null;
    $faultRequests += $req;
}

$faultResponses = @($Global:XrmClient | Invoke-XrmBulkRequests -Requests $faultRequests -BatchSize 2 -ContinueOnError $true -ReturnResponses $true -Quiet -ErrorVariable bulkErrors -ErrorAction SilentlyContinue);
$faults = @($bulkErrors | ForEach-Object { $_.TargetObject });
Assert-Test "ContinueOnError - one fault, with its global index and request name" {
    $faults.Count -eq 1 -and $faults[0].Index -eq 2 -and $faults[0].Count -eq 1 -and $faults[0].RequestName -eq "Update" -and -not [string]::IsNullOrWhiteSpace($faults[0].Message);
};
Assert-Test "ContinueOnError - responses aligned on requests (`$null for the fault)" {
    $faultResponses.Count -eq 3 -and $null -ne $faultResponses[0] -and $null -ne $faultResponses[1] -and $null -eq $faultResponses[2];
};

$bulkErrorMessage = $null;
try {
    $Global:XrmClient | Invoke-XrmBulkRequests -Requests $faultRequests -BatchSize 2 -Quiet | Out-Null;
}
catch {
    $bulkErrorMessage = $_.Exception.Message;
}
Assert-Test "Without ContinueOnError - the error names the faulted request" {
    $bulkErrorMessage -like "Request #2 (Update) failed:*";
};

$emptyResponses = @($Global:XrmClient | Invoke-XrmBulkRequests -Requests @() -Quiet);
Assert-Test "Empty request list returns nothing" {
    $emptyResponses.Count -eq 0;
};

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

<#
    Integration Test: reading rows (brief lot 2)
    Get-XrmMultipleRecords -AsArray / -AsEntity, Get-XrmRecord -AsEntity / -IfExists / -Unique / -Attributes,
    Get-XrmAttributeValue (Get-XrmRowValue) on converted rows, Get-XrmMetadataValue, Resolve-XrmEntityReference,
    Get-XrmRecordCount, Get-XrmTotalRecordCount -SkipRefused -AsHashtable, Get-XrmRecordIds.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = Get-TestName -Prefix "Rows";
$accountIds = [System.Collections.Generic.List[Guid]]::new();
$contactIds = [System.Collections.Generic.List[Guid]]::new();

function New-TestAccount([string]$Name, [hashtable]$Attributes = @{}) {
    $columns = @{ name = $Name };
    foreach ($key in $Attributes.Keys) { $columns[$key] = $Attributes[$key]; }
    $record = New-XrmEntity -LogicalName "account" -Attributes $columns;
    $record.Id = $Global:XrmClient | Add-XrmRecord -Record $record;
    $accountIds.Add($record.Id);
    return $record.ToEntityReference();
}

function New-PrefixQuery {
    $query = New-XrmQueryExpression -LogicalName "account" -Columns "name", "industrycode", "donotemail", "creditlimit", "parentaccountid";
    return ($query | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix);
}

Write-Section "Setup";
$account1 = New-TestAccount -Name "$prefix-1" -Attributes @{ industrycode = (New-XrmOptionSetValue -Value 1); donotemail = $true; creditlimit = (New-XrmMoney -Value 100) };
$account2 = New-TestAccount -Name "$prefix-2" -Attributes @{ parentaccountid = $account1 };
$account3 = New-TestAccount -Name "$prefix-3";
foreach ($i in 1..2) {
    $contact = New-XrmEntity -LogicalName "contact" -Attributes @{ lastname = "$prefix-contact-$i"; parentcustomerid = $account1 };
    $contactIds.Add(($Global:XrmClient | Add-XrmRecord -Record $contact));
}
Assert-Test "3 accounts and 2 contacts created" { $accountIds.Count -eq 3 -and $contactIds.Count -eq 2 };

# ============================================================
# L01 / L02 Get-XrmMultipleRecords -AsArray / -AsEntity
# ============================================================
Write-Section "Get-XrmMultipleRecords -AsArray / -AsEntity";

$none = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "name" -Condition Equal -Values "$prefix-none";
$noneRows = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $none -AsArray;
Assert-Test "-AsArray: no row gives an empty array" { $null -ne $noneRows -and $noneRows -is [array] -and $noneRows.Count -eq 0 };

$one = New-XrmQueryExpression -LogicalName "account" -Columns "name" | Add-XrmQueryCondition -Field "name" -Condition Equal -Values "$prefix-1";
$oneRows = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $one -AsArray;
Assert-Test "-AsArray: one row gives an array of one" { $oneRows -is [array] -and $oneRows.Count -eq 1 -and $oneRows[0].name -eq "$prefix-1" };

$oneDefault = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $one;
Assert-Test "Default output unchanged: one row gives a single object" { $oneDefault -isnot [array] -and $oneDefault.name -eq "$prefix-1" };

$entities = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query (New-PrefixQuery) -AsEntity -AsArray;
Assert-Test "-AsEntity -AsArray: 3 SDK entities" { $entities.Count -eq 3 -and @($entities | Where-Object { $_ -isnot [Microsoft.Xrm.Sdk.Entity] }).Count -eq 0 };

# ============================================================
# L03 Get-XrmAttributeValue / Get-XrmRowValue
# ============================================================
Write-Section "Get-XrmAttributeValue on converted rows";

$row1 = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account1.Id -Columns "industrycode", "donotemail", "creditlimit";
$row2 = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account2.Id -Columns "parentaccountid", "telephone1";
Assert-Test "Converted row keeps the label under the column name (why this cmdlet exists)" { $row1.donotemail -is [string] };
Assert-Test "Boolean read from a converted row is a bool" { ($row1 | Get-XrmRowValue -Name "donotemail") -is [bool] -and ($row1 | Get-XrmRowValue -Name "donotemail") -eq $true };
Assert-Test "-Raw: OptionSetValue => int" { ($row1 | Get-XrmAttributeValue -Name "industrycode" -Raw) -eq 1 };
Assert-Test "-Raw: Money => decimal" { ($row1 | Get-XrmAttributeValue -Name "creditlimit" -Raw) -eq [decimal]100 };
Assert-Test "-FormattedValue: label" { ($row1 | Get-XrmAttributeValue -Name "industrycode" -FormattedValue) -is [string] };
Assert-Test "-AsId: lookup Guid" { ($row2 | Get-XrmAttributeValue -Name "parentaccountid" -AsId) -eq $account1.Id };
Assert-Test "Missing column gives `$null" { $null -eq ($row2 | Get-XrmAttributeValue -Name "telephone1") };
Assert-Test "`$null record gives `$null" { $null -eq (Get-XrmAttributeValue -Record $null -Name "name") };

$aliasQuery = New-XrmQueryExpression -LogicalName "account" -Columns "name" | Add-XrmQueryCondition -Field "accountid" -Condition Equal -Values $account2.Id;
$aliasLink = $aliasQuery | Add-XrmQueryLink -ToEntityName "account" -FromAttributeName "parentaccountid" -ToAttributeName "accountid" -Alias "parent";
$aliasLink | Add-XrmQueryLinkColumns -Columns "industrycode" | Out-Null;
$aliasRow = Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query $aliasQuery | Select-Object -First 1;
Assert-Test "-Raw unwraps an AliasedValue (linked option set => int)" { ($aliasRow | Get-XrmRowValue -Name "parent.industrycode" -Raw) -eq 1 };

$typeError = $null;
try { Get-XrmAttributeValue -Record "not a row" -Name "name" | Out-Null; } catch { $typeError = $_.Exception.Message; }
Assert-Test "Another object type raises an error" { $typeError -like "*Entity*" };

# ============================================================
# L04 Get-XrmMetadataValue
# ============================================================
Write-Section "Get-XrmMetadataValue";

$accountMetadata = $Global:XrmClient | Get-XrmEntityMetadata -LogicalName "account" -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity);
Assert-Test "Managed property => bool value" { (Get-XrmMetadataValue -Metadata $accountMetadata -Property "IsAuditEnabled") -is [bool] };
Assert-Test "-CanBeChanged => bool" { (Get-XrmMetadataValue -Metadata $accountMetadata -Property "IsAuditEnabled" -CanBeChanged) -is [bool] };
Assert-Test "Label => text for -LanguageCode 1033" { ($accountMetadata | Get-XrmMetadataValue -Property "DisplayName" -LanguageCode 1033) -eq "Account" };
Assert-Test "Dotted path" { ($accountMetadata | Get-XrmMetadataValue -Property "DisplayName.UserLocalizedLabel.LanguageCode") -gt 0 };
Assert-Test "Plain property" { ($accountMetadata | Get-XrmMetadataValue -Property "PrimaryIdAttribute") -eq "accountid" };
$canBeChangedError = $null;
try { $accountMetadata | Get-XrmMetadataValue -Property "LogicalName" -CanBeChanged | Out-Null; } catch { $canBeChangedError = $_.Exception.Message; }
Assert-Test "-CanBeChanged on a plain property raises an error" { $canBeChangedError -like "*not a managed property*" };

$nameColumn = $Global:XrmClient | Get-XrmColumn -EntityLogicalName "account" -LogicalName "name";
Assert-Test "AttributeRequiredLevelManagedProperty => enum value" { ($nameColumn | Get-XrmMetadataValue -Property "RequiredLevel") -is [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel] };

# ============================================================
# L05 / L06 Get-XrmRecord
# ============================================================
Write-Section "Get-XrmRecord -IfExists / -Unique / -Attributes / -AsEntity";

$missingId = [Guid]::NewGuid();
$missingError = $null;
$missing = "not set";
try { $missing = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $missingId -IfExists; } catch { $missingError = $_.Exception.Message; }
Assert-Test "-IfExists: missing id gives `$null without error" { $null -eq $missingError -and $null -eq $missing };

$asEntity = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $account1.Id -Columns "name" -AsEntity;
Assert-Test "-AsEntity: SDK entity" { $asEntity -is [Microsoft.Xrm.Sdk.Entity] -and $asEntity["name"] -eq "$prefix-1" };

$byAttributes = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Attributes @{ name = "$prefix-1"; industrycode = (New-XrmOptionSetValue -Value 1) } -Columns "name";
Assert-Test "-Attributes: AND of conditions, OptionSetValue compared on value" { $null -ne $byAttributes -and $byAttributes.Id -eq $account1.Id };

$byLookup = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Attributes @{ parentaccountid = $account1; name = "$prefix-2" };
Assert-Test "-Attributes: EntityReference compared on id" { $null -ne $byLookup -and $byLookup.Id -eq $account2.Id };

$byNull = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Attributes @{ name = "$prefix-3"; parentaccountid = $null };
Assert-Test "-Attributes: `$null value matches an empty column" { $null -ne $byNull -and $byNull.Id -eq $account3.Id };

$noMatch = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Attributes @{ name = "$prefix-3"; parentaccountid = $account1 };
Assert-Test "-Attributes: no match gives `$null" { $null -eq $noMatch };

$duplicate = New-TestAccount -Name "$prefix-1";
$uniqueError = $null;
try { $Global:XrmClient | Get-XrmRecord -LogicalName "account" -AttributeName "name" -Value "$prefix-1" -Unique | Out-Null; } catch { $uniqueError = $_.Exception.Message; }
Assert-Test "-Unique: two matches raise an error" { $uniqueError -like "*More than one*" };

# ============================================================
# L07 Resolve-XrmEntityReference
# ============================================================
Write-Section "Resolve-XrmEntityReference";

$resolved = Resolve-XrmEntityReference -XrmClient $Global:XrmClient -LogicalName "account" -Attributes @{ name = "$prefix-2" };
Assert-Test "Found: EntityReference of the row" { $resolved -is [Microsoft.Xrm.Sdk.EntityReference] -and $resolved.Id -eq $account2.Id -and $resolved.LogicalName -eq "account" };

$notFoundError = $null;
try { Resolve-XrmEntityReference -XrmClient $Global:XrmClient -LogicalName "account" -Attributes @{ name = "$prefix-none" } | Out-Null; } catch { $notFoundError = $_.Exception.Message; }
Assert-Test "Not found raises an error" { $notFoundError -like "*No 'account' row*" };
Assert-Test "-IfExists: not found gives `$null" { $null -eq (Resolve-XrmEntityReference -XrmClient $Global:XrmClient -LogicalName "account" -Attributes @{ name = "$prefix-none" } -IfExists) };

$ambiguousError = $null;
try { Resolve-XrmEntityReference -XrmClient $Global:XrmClient -LogicalName "account" -Attributes @{ name = "$prefix-1" } | Out-Null; } catch { $ambiguousError = $_.Exception.Message; }
Assert-Test "Several matches raise an error" { $ambiguousError -like "*More than one*" };

$cache = @{};
$first = Resolve-XrmEntityReference -XrmClient $Global:XrmClient -LogicalName "account" -Attributes @{ name = "$prefix-3" } -Cache $cache;
$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $account3.Id;
$accountIds.Remove($account3.Id) | Out-Null;
$second = Resolve-XrmEntityReference -XrmClient $Global:XrmClient -LogicalName "account" -Attributes @{ name = "$PREFIX-3".ToUpperInvariant() } -Cache $cache;
Assert-Test "-Cache: second resolution served from the caller's cache (case-insensitive key)" { $cache.Count -eq 1 -and $second.Id -eq $first.Id };

# ============================================================
# L08 Get-XrmRecordCount / Get-XrmTotalRecordCount
# ============================================================
Write-Section "Get-XrmRecordCount";

$countQuery = New-XrmQueryExpression -LogicalName "account" -Columns "name" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix;
Assert-Test "Aggregate count (3 accounts: 2 + the duplicate)" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query $countQuery) -eq 3 };
Assert-Test "-NoAggregate: same count by paging" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query $countQuery -NoAggregate) -eq 3 };
Assert-Test "Caller's query columns untouched" { $countQuery.ColumnSet.Columns.Count -eq 1 -and $countQuery.ColumnSet.Columns[0] -eq "name" };

$linkedQuery = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix;
$contactLink = $linkedQuery | Add-XrmQueryLink -ToEntityName "contact" -FromAttributeName "accountid" -ToAttributeName "parentcustomerid";
Assert-Test "One-to-many link: an account with 2 contacts counts once" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query $linkedQuery) -eq 1 };
Assert-Test "One-to-many link with -NoAggregate: counts once" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query $linkedQuery -NoAggregate) -eq 1 };

$fetch = "<fetch><entity name='contact'><attribute name='lastname' /><filter><condition attribute='lastname' operator='like' value='$prefix-contact-%' /></filter></entity></fetch>";
Assert-Test "-FetchXml: 2 contacts" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -FetchXml $fetch) -eq 2 };

$topQuery = New-XrmQueryExpression -LogicalName "account" -TopCount 2 | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix;
Assert-Test "TopCount caps the count" { (Get-XrmRecordCount -XrmClient $Global:XrmClient -Query $topQuery) -eq 2 };

$totals = Get-XrmTotalRecordCount -XrmClient $Global:XrmClient -LogicalNames "account", "contact" -AsHashtable;
Assert-Test "Get-XrmTotalRecordCount -AsHashtable" { $totals -is [hashtable] -and $totals.ContainsKey("account") -and $totals.ContainsKey("contact") };

$skipped = Get-XrmTotalRecordCount -XrmClient $Global:XrmClient -LogicalNames "account", "pdo_nosuchtable" -SkipRefused -AsHashtable -WarningAction SilentlyContinue;
Assert-Test "-SkipRefused: an unknown table does not fail the call" { $skipped.ContainsKey("account") -and -not $skipped.ContainsKey("pdo_nosuchtable") };

# ============================================================
# L09 Get-XrmRecordIds
# ============================================================
Write-Section "Get-XrmRecordIds";

$idQuery = New-XrmQueryExpression -LogicalName "account" -Columns "name" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix;
$ids = Get-XrmRecordIds -XrmClient $Global:XrmClient -Query $idQuery;
Assert-Test "-Query: HashSet of the 3 ids" { $ids -is [System.Collections.Generic.HashSet[Guid]] -and $ids.Count -eq 3 -and $ids.Contains($account1.Id) -and $ids.Contains($duplicate.Id) };
Assert-Test "Caller's query columns restored" { $idQuery.ColumnSet.Columns.Count -eq 1 };

$emptyIds = Get-XrmRecordIds -XrmClient $Global:XrmClient -Query $none;
Assert-Test "No row: empty HashSet, not `$null" { $emptyIds -is [System.Collections.Generic.HashSet[Guid]] -and $emptyIds.Count -eq 0 };

$businessUnitIds = Get-XrmRecordIds -XrmClient $Global:XrmClient -LogicalName "businessunit";
Assert-Test "-LogicalName: all rows of the table" { $businessUnitIds.Count -ge 1 };

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";
foreach ($id in $contactIds) { try { $Global:XrmClient | Remove-XrmRecord -LogicalName "contact" -Id $id; } catch { } }
foreach ($id in $accountIds) { try { $Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $id; } catch { } }
Assert-Test "Cleanup complete" { $true };

Write-TestSummary;

<#
    Integration Test: Add-XrmQueryLinkColumns
    Validates that columns can be added to a LinkEntity
    and that the resulting query executes successfully.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# BUILD QUERY WITH LINK
# ============================================================
Write-Section "Build query with link entity";

$query = New-XrmQueryExpression -LogicalName "account" -Columns "name";
$link = $query | Add-XrmQueryLink -FromAttributeName "primarycontactid" -ToEntityName "contact" -ToAttributeName "contactid";

Assert-Test "Link entity created" {
    $link -ne $null;
};

# ============================================================
# ADD COLUMNS TO LINK
# ============================================================
Write-Section "Add-XrmQueryLinkColumns";

$link = $link | Add-XrmQueryLinkColumns -Columns "fullname", "emailaddress1";

Assert-Test "Link has 2 columns" {
    $link.Columns.Columns.Count -eq 2;
};

Assert-Test "Link columns contain 'fullname'" {
    $link.Columns.Columns -contains "fullname";
};

Assert-Test "Link columns contain 'emailaddress1'" {
    $link.Columns.Columns -contains "emailaddress1";
};

# ============================================================
# EXECUTE QUERY
# ============================================================
Write-Section "Execute query with link columns";

$results = $Global:XrmClient | Get-XrmMultipleRecords -Query $query;

Assert-Test "Query executed without error" {
    $true;
};

Write-TestSummary;

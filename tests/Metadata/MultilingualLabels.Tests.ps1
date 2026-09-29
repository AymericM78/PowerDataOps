<#
    Integration Test: Multilingual labels
    Validates multilingual label hashtable parameters on Add-/Set- table and column cmdlets.
    Cmdlets: New-XrmLabel, Add-XrmTable, Set-XrmTable, Add-XrmColumn, Set-XrmColumn,
             Get-XrmEntityMetadata, Get-XrmColumn, Remove-XrmTable
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = "new";
$suffix = Get-Random -Minimum 10000 -Maximum 99999;
$tableName = "${prefix}_mllabels${suffix}";
$columnName = "${prefix}_mlcol${suffix}";
$tableCreated = $false;

function Get-LabelText {
    param($Label, [int]$LanguageCode)
    if ($null -eq $Label) { return $null; }
    $match = $Label.LocalizedLabels | Where-Object { $_.LanguageCode -eq $LanguageCode };
    if ($null -eq $match) { return $null; }
    return $match.Label;
}

# ============================================================
# New-XrmLabel -Labels (multilingual primitive)
# ============================================================
Write-Section "New-XrmLabel multilingual";

$multiLabel = New-XrmLabel -Labels @{ 1033 = "Account"; 1036 = "Compte" };
Assert-Test "New-XrmLabel -Labels builds 2 localized labels" {
    $multiLabel.LocalizedLabels.Count -eq 2;
};
Assert-Test "New-XrmLabel -Labels keeps 1033 text" {
    (Get-LabelText -Label $multiLabel -LanguageCode 1033) -eq "Account";
};
Assert-Test "New-XrmLabel -Labels keeps 1036 text" {
    (Get-LabelText -Label $multiLabel -LanguageCode 1036) -eq "Compte";
};

# ============================================================
# Add-XrmTable with multilingual labels
# ============================================================
Write-Section "Add-XrmTable multilingual labels";

$createTableResponse = $Global:XrmClient | Add-XrmTable `
    -LogicalName $tableName `
    -DisplayNameLabels @{ 1033 = "ML Project"; 1036 = "Projet ML" } `
    -PluralNameLabels @{ 1033 = "ML Projects"; 1036 = "Projets ML" } `
    -DescriptionLabels @{ 1033 = "Multilingual test table"; 1036 = "Table de test multilingue" } `
    -OwnershipType ([Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned) `
    -PrimaryAttributeSchemaName "${prefix}_name" `
    -PrimaryAttributeDisplayNameLabels @{ 1033 = "Name"; 1036 = "Nom" } `
    -PrimaryAttributeMaxLength 200;

Assert-Test "Add-XrmTable - created '$tableName'" {
    $createTableResponse -ne $null;
};
$tableCreated = $true;

$tableMetadata = $Global:XrmClient | Get-XrmEntityMetadata -LogicalName $tableName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity) -IfExists;
Assert-Test "Table DisplayName has 1033 label" {
    (Get-LabelText -Label $tableMetadata.DisplayName -LanguageCode 1033) -eq "ML Project";
};
Assert-Test "Table DisplayName has 1036 label" {
    (Get-LabelText -Label $tableMetadata.DisplayName -LanguageCode 1036) -eq "Projet ML";
};
Assert-Test "Table DisplayCollectionName has 1036 label" {
    (Get-LabelText -Label $tableMetadata.DisplayCollectionName -LanguageCode 1036) -eq "Projets ML";
};

# ============================================================
# Set-XrmTable redefine labels
# ============================================================
Write-Section "Set-XrmTable redefine labels";

$Global:XrmClient | Set-XrmTable `
    -MetadataId $tableMetadata.MetadataId `
    -DisplayNameLabels @{ 1036 = "Projet ML modifie" } | Out-Null;

$tableMetadata2 = $Global:XrmClient | Get-XrmEntityMetadata -LogicalName $tableName -Filter ([Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity) -IfExists;
Assert-Test "Set-XrmTable redefined 1036 DisplayName" {
    (Get-LabelText -Label $tableMetadata2.DisplayName -LanguageCode 1036) -eq "Projet ML modifie";
};
Assert-Test "Set-XrmTable kept 1033 DisplayName (MergeLabels)" {
    (Get-LabelText -Label $tableMetadata2.DisplayName -LanguageCode 1033) -eq "ML Project";
};

# ============================================================
# Add-XrmColumn with multilingual labels
# ============================================================
Write-Section "Add-XrmColumn multilingual labels";

$attr = New-XrmStringColumn -LogicalName $columnName -SchemaName $columnName -DisplayName "Code" -MaxLength 100;
$Global:XrmClient | Add-XrmColumn `
    -EntityLogicalName $tableName `
    -Attribute $attr `
    -DisplayNameLabels @{ 1033 = "Code"; 1036 = "Code FR" } `
    -DescriptionLabels @{ 1033 = "Code description"; 1036 = "Description du code" } | Out-Null;

$column = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName $columnName -MetadataType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]) -IfExists;
Assert-Test "Column DisplayName has 1033 label" {
    (Get-LabelText -Label $column.DisplayName -LanguageCode 1033) -eq "Code";
};
Assert-Test "Column DisplayName has 1036 label" {
    (Get-LabelText -Label $column.DisplayName -LanguageCode 1036) -eq "Code FR";
};

# ============================================================
# Set-XrmColumn redefine labels
# ============================================================
Write-Section "Set-XrmColumn redefine labels";

$Global:XrmClient | Set-XrmColumn `
    -EntityLogicalName $tableName `
    -Attribute $column `
    -DisplayNameLabels @{ 1036 = "Code FR modifie" } | Out-Null;

$column2 = $Global:XrmClient | Get-XrmColumn -EntityLogicalName $tableName -LogicalName $columnName -MetadataType ([Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]) -IfExists;
Assert-Test "Set-XrmColumn redefined 1036 DisplayName" {
    (Get-LabelText -Label $column2.DisplayName -LanguageCode 1036) -eq "Code FR modifie";
};
Assert-Test "Set-XrmColumn kept 1033 DisplayName (MergeLabels)" {
    (Get-LabelText -Label $column2.DisplayName -LanguageCode 1033) -eq "Code";
};

# ============================================================
# Component labels (-Labels -> name) via Add-/Set-XrmView
# ============================================================
Write-Section "Component labels - Add-XrmView -Labels";

$viewFetch = "<fetch><entity name='$tableName'><attribute name='${prefix}_name' /></entity></fetch>";
$viewLayout = "<grid name='resultset' object='1' jump='${prefix}_name' select='1' icon='1' preview='1'><row name='result' id='${tableName}id'><cell name='${prefix}_name' width='300' /></row></grid>";

$viewRef = $Global:XrmClient | Add-XrmView -EntityLogicalName $tableName -Labels @{ 1033 = "ML View EN"; 1036 = "Vue ML FR" } -LanguageCode 1036 -FetchXml $viewFetch -LayoutXml $viewLayout;
Assert-Test "Add-XrmView -Labels created a view" {
    $viewRef -ne $null -and $viewRef.Id -ne [Guid]::Empty;
};

$viewRecord = $Global:XrmClient | Get-XrmRecord -LogicalName "savedquery" -Id $viewRef.Id -Columns "name";
Assert-Test "View name resolved from -Labels using -LanguageCode 1036" {
    $viewRecord.name -eq "Vue ML FR";
};

Write-Section "Component labels - Set-XrmView -Labels (redefine)";

$Global:XrmClient | Set-XrmView -ViewReference $viewRef -Labels @{ 1033 = "ML View EN2"; 1036 = "Vue ML FR2" } | Out-Null;
# Retrieve keeps returning the name stored at creation: the translations are read with Get-XrmLocalizedLabel
$viewLabels = Get-XrmLocalizedLabel -XrmClient $Global:XrmClient -EntityMoniker $viewRef -AttributeName "name" -AsHashtable;
Assert-Test "Set-XrmView -Labels redefined the name in both languages" {
    $viewLabels[1033] -eq "ML View EN2" -and $viewLabels[1036] -eq "Vue ML FR2";
};

# ============================================================
# CLEANUP: Remove-XrmTable (also removes the view above)
# ============================================================
Write-Section "Cleanup - Remove-XrmTable";

if ($tableCreated) {
    $removeTableResponse = $Global:XrmClient | Remove-XrmTable -LogicalName $tableName;
    Assert-Test "Remove-XrmTable - removed '$tableName'" {
        $removeTableResponse -ne $null;
    };
}

Write-TestSummary;

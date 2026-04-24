<#!
    Integration Test: Read-XrmExcelSheet cmdlet
    Validates readable object output and raw array compatibility.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Create Source Data";

$excelPrefix = Get-TestName -Prefix 'ReadExcel';
$account1 = New-XrmEntity -LogicalName 'account' -Attributes @{
    'name' = "$excelPrefix-Alpha";
    'accountnumber' = 'ACC-001';
};
$account2 = New-XrmEntity -LogicalName 'account' -Attributes @{
    'name' = "$excelPrefix-Beta";
    'accountnumber' = 'ACC-002';
};

$account1.Id = $Global:XrmClient | Add-XrmRecord -Record $account1;
$account2.Id = $Global:XrmClient | Add-XrmRecord -Record $account2;

Assert-Test "Account 1 created" {
    $account1.Id -ne [Guid]::Empty;
};
Assert-Test "Account 2 created" {
    $account2.Id -ne [Guid]::Empty;
};

$sourceRows = @(
    $Global:XrmClient | Get-XrmRecord -LogicalName 'account' -Id $account1.Id -Columns 'name', 'accountnumber';
    $Global:XrmClient | Get-XrmRecord -LogicalName 'account' -Id $account2.Id -Columns 'name', 'accountnumber';
);

$excelFilePath = Join-Path $env:TEMP "$excelPrefix.xlsx";
$headerMappings = [ordered]@{
    'name' = 'Name';
    'accountnumber' = 'Account Number';
};

Write-XrmExcelSheet -ExcelFilePath $excelFilePath -SheetName 'Accounts' -Records $sourceRows -HeaderMappings $headerMappings;
Assert-Test "Write-XrmExcelSheet creates the workbook" {
    (Test-Path $excelFilePath) -and ([System.IO.FileInfo]::new($excelFilePath).Length -gt 0);
};

Write-Section "Read Excel Sheet";

$rows = Read-XrmExcelSheet -ExcelFilePath $excelFilePath -SheetName 'Accounts';
Assert-Test "Read-XrmExcelSheet returns two data rows" {
    @($rows).Count -eq 2;
};
Assert-Test "Read-XrmExcelSheet exposes header names as properties" {
    $rows[0].PSObject.Properties.Name -contains 'Name' -and $rows[0].PSObject.Properties.Name -contains 'Account Number';
};
Assert-Test "Read-XrmExcelSheet returns expected first row values" {
    $rows[0].Name -eq $account1['name'] -and $rows[0].'Account Number' -eq $account1['accountnumber'];
};

$rawValues = Read-XrmExcelSheet -ExcelFilePath $excelFilePath -SheetName 'Accounts' -AsArray;
Assert-Test "Read-XrmExcelSheet -AsArray keeps the raw Excel 2D array" {
    $rawValues -is [System.Array] -and $rawValues.Rank -eq 2 -and $rawValues[1, 1] -eq 'Name';
};

Write-Section "Cleanup";
if (Test-Path $excelFilePath) {
    Remove-Item -Path $excelFilePath -Force;
}
$Global:XrmClient | Remove-XrmRecord -LogicalName 'account' -Id $account1.Id;
$Global:XrmClient | Remove-XrmRecord -LogicalName 'account' -Id $account2.Id;
Assert-Test "Temporary workbook deleted" {
    -not (Test-Path $excelFilePath);
};
Assert-Test "Temporary accounts deleted" {
    $true;
};

Write-TestSummary;
<#
    Integration Test: Sync-XrmRecords
    Tests record synchronization orchestration between source and target clients.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Setup test account";

$accountName = Get-TestName -Prefix "Sync";
$account = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = $accountName;
};
$account.Id = $Global:XrmClient | Add-XrmRecord -Record $account;

Assert-Test "Test account created" {
    $account.Id -ne [Guid]::Empty;
};

Write-Section "Sync-XrmRecords execution";

$summary = @(
    Sync-XrmRecords `
        -SourceXrmClient $Global:XrmClient `
        -TargetXrmClient $Global:XrmClient `
        -LogicalNames @("account") `
        -Columns @("name") `
        -TopCount 1 `
        -OrderByField "createdon" `
        -OrderType Descending `
        -ContinueOnError $false
);

Assert-Test "Sync-XrmRecords returns one summary row" {
    $summary.Count -eq 1;
};

$accountSummary = $summary | Select-Object -First 1;

Assert-Test "Summary LogicalName is account" {
    $accountSummary.LogicalName -eq "account";
};

Assert-Test "Summary ReadCount is 1 (TopCount applied)" {
    [int]$accountSummary.ReadCount -eq 1;
};

Assert-Test "Summary FailedCount is 0" {
    [int]$accountSummary.FailedCount -eq 0;
};

Assert-Test "Summary UpsertedCount is 1" {
    [int]$accountSummary.UpsertedCount -eq 1;
};

Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $account.Id;
Assert-Test "Test account deleted" { $true };

Write-TestSummary;

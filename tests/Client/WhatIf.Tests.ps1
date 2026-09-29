<#
    Integration Test: -WhatIf (brief lot 3c, E07)
    Writes asked with -WhatIf change nothing, directly, nested (Set-XrmRecordState => Update-XrmRecord => Invoke-XrmRequest)
    or in batches; reads still run.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$prefix = Get-TestName -Prefix "WhatIf";

Write-Section "Setup";
$accountId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Attributes @{ name = "$prefix-real"; description = "original" });
Assert-Test "Real account created" { $accountId -ne [Guid]::Empty };
$accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;

function Get-Description { ($Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -Columns "description").description }

Write-Section "Direct writes";
$whatIfId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Attributes @{ name = "$prefix-whatif" }) -WhatIf;
$whatIfRow = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -AttributeName "name" -Value "$prefix-whatif";
Assert-Test "Add-XrmRecord -WhatIf: nothing created, nothing returned" { $null -eq $whatIfId -and $null -eq $whatIfRow };

$Global:XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ description = "changed" }) -WhatIf;
Assert-Test "Update-XrmRecord -WhatIf: unchanged" { (Get-Description) -eq "original" };

$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $accountId -WhatIf;
Assert-Test "Remove-XrmRecord -WhatIf: still there" { $null -ne ($Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -IfExists) };

Write-Section "Nested and batch writes";
$Global:XrmClient | Set-XrmRecordState -RecordReference $accountRef -StateCode 1 -StatusCode 2 -WhatIf | Out-Null;
$state = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -Columns "statecode";
Assert-Test "Set-XrmRecordState -WhatIf (nested Update-XrmRecord): still active" { ($state | Get-XrmRowValue -Name "statecode" -Raw) -eq 0 };

$records = @(New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ description = "batch" });
Update-XrmRecords -XrmClient $Global:XrmClient -Records $records -Quiet -WhatIf | Out-Null;
Assert-Test "Update-XrmRecords -WhatIf (sequential batch): unchanged" { (Get-Description) -eq "original" };

Update-XrmRecords -XrmClient $Global:XrmClient -Records $records -Parallel -ThreadCount 2 -Quiet -WhatIf | Out-Null;
Assert-Test "Update-XrmRecords -Parallel -WhatIf: unchanged" { (Get-Description) -eq "original" };

$deleteQuery = New-XrmQueryExpression -LogicalName "account" | Add-XrmQueryCondition -Field "name" -Condition BeginsWith -Values $prefix;
$bulkStatus = $Global:XrmClient | Add-XrmBulkDelete -Query $deleteQuery -JobName "PowerDataOps test $prefix" -Wait -WhatIf;
Assert-Test "Add-XrmBulkDelete -Wait -WhatIf: no job, no error, account still there" { $null -eq $bulkStatus -and $null -ne ($Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -IfExists) };

Write-Section "Reads still run under -WhatIf";
$read = $Global:XrmClient | Invoke-XrmRequest -Request (New-XrmRequest -Name "WhoAmI") -WhatIf;
Assert-Test "Invoke-XrmRequest -WhatIf on a read request: executed" { $null -ne $read -and $read.Results["UserId"] -ne [Guid]::Empty };

Write-Section "Without -WhatIf";
$Global:XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Id $accountId -Attributes @{ description = "changed" });
Assert-Test "Update-XrmRecord without -WhatIf: applied (no prompt with the default ConfirmPreference)" { (Get-Description) -eq "changed" };

Write-Section "Cleanup";
$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $accountId;
Assert-Test "Cleanup complete" { $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "account" -Id $accountId -IfExists) };

Write-TestSummary;

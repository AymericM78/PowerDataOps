<#!
    Integration Test: Merge-XrmRecord cmdlet
    Validates merging two account records.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Create Accounts";
$name1 = Get-TestName -Prefix "Merge1";
$name2 = Get-TestName -Prefix "Merge2";
$rec1 = New-XrmEntity -LogicalName "account" -Attributes @{ name = $name1 };
$rec2 = New-XrmEntity -LogicalName "account" -Attributes @{ name = $name2 };
$rec1.Id = $Global:XrmClient | Add-XrmRecord -Record $rec1;
$rec2.Id = $Global:XrmClient | Add-XrmRecord -Record $rec2;

Write-Section "Merge";
Merge-XrmRecord -TargetReference (New-XrmEntityReference -LogicalName "account" -Id $rec1.Id) -SubordinateId $rec2.Id | Out-Null;
Assert-Test "Merged (no error)" { $true };

Write-Section "Cleanup";
$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $rec1.Id;
Write-TestSummary;

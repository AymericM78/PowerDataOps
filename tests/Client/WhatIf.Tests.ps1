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
$whatIfId = $Global:XrmClient | Add-XrmRecord -Record (New-XrmEntity -LogicalName "account" -Attributes @{ name = "$prefix-whatif" }) -WhatIf -ErrorVariable addErrors;
$whatIfRow = $Global:XrmClient | Get-XrmRecord -LogicalName "account" -AttributeName "name" -Value "$prefix-whatif";
Assert-Test "Add-XrmRecord -WhatIf: nothing created, nothing returned, no error" { $null -eq $whatIfId -and $null -eq $whatIfRow -and $addErrors.Count -eq 0 };

$copiedForm = $Global:XrmClient | Copy-XrmForm -SourceFormId ([Guid]::NewGuid()) -NewName "$prefix-form" -WhatIf -ErrorVariable copyErrors;
Assert-Test "Copy-XrmForm -WhatIf: nothing returned, no error" { $null -eq $copiedForm -and $copyErrors.Count -eq 0 };

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

Write-Section "Create cmdlets under -WhatIf: nothing returned, no error";
$defaultPublisher = (Get-XrmSolution -XrmClient $Global:XrmClient -SolutionUniqueName "Default" -Columns "publisherid").publisherid_Value;
$iconId = @(Get-XrmMultipleRecords -XrmClient $Global:XrmClient -Query (New-XrmQueryExpression -LogicalName "webresource" -Columns "name" -TopCount 1 | Add-XrmQueryCondition -Field "webresourcetype" -Condition Equal -Values 11))[0].Id;
$webResourceFolder = Join-Path ([System.IO.Path]::GetTempPath()) "pdo-whatif-$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
New-Item -ItemType Directory -Path (Join-Path $webResourceFolder "new_") -Force | Out-Null;
Set-Content -Path (Join-Path $webResourceFolder "new_\pdowhatif.js") -Value "// what if";
$createCalls = [ordered]@{
    "Add-XrmSecurityRole"    = { Add-XrmSecurityRole -XrmClient $Global:XrmClient -Name "$prefix-role" -WhatIf -ErrorAction Stop };
    "Add-XrmConnectionRole"  = { Add-XrmConnectionRole -XrmClient $Global:XrmClient -Name "$prefix-connectionrole" -WhatIf -ErrorAction Stop };
    "Add-XrmSiteMap"         = { Add-XrmSiteMap -XrmClient $Global:XrmClient -Name "$prefix-sitemap" -SiteMapXml "<SiteMap />" -WhatIf -ErrorAction Stop };
    "Add-XrmAppModule"       = { Add-XrmAppModule -XrmClient $Global:XrmClient -Name "$prefix-app" -UniqueName "pdowhatifapp" -WebResourceId $iconId -WhatIf -ErrorAction Stop };
    "Add-XrmPublisher"       = { Add-XrmPublisher -XrmClient $Global:XrmClient -UniqueName "pdowhatifpub" -DisplayName "$prefix" -Prefix "pdw" -OptionValuePrefix 12345 -WhatIf -ErrorAction Stop };
    "Add-XrmSolution"        = { Add-XrmSolution -XrmClient $Global:XrmClient -UniqueName "pdowhatifsol" -DisplayName "$prefix" -PublisherReference $defaultPublisher -WhatIf -ErrorAction Stop };
    "Upsert-XrmWebResource"  = { Upsert-XrmWebResource -XrmClient $Global:XrmClient -FilePath (Join-Path $webResourceFolder "new_\pdowhatif.js") -SolutionUniqueName "Default" -Prefix "new_" -WhatIf -ErrorAction Stop };
};
foreach ($cmdletName in $createCalls.Keys) {
    $callError = $null;
    $callOutput = $null;
    try { $callOutput = & $createCalls[$cmdletName]; } catch { $callError = $_.Exception.Message; }
    Assert-Test "$cmdletName -WhatIf: nothing returned, no error $callError" { $null -eq $callError -and $null -eq $callOutput };
}
Remove-Item -Path $webResourceFolder -Recurse -Force -ErrorAction SilentlyContinue;
Assert-Test "Nothing created by the -WhatIf calls" {
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "role" -AttributeName "name" -Value "$prefix-role") -and
    $null -eq ($Global:XrmClient | Get-XrmRecord -LogicalName "webresource" -AttributeName "name" -Value "new_/pdowhatif.js");
};

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

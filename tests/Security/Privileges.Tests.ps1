<#
    Integration Test: privileges, roles and users (brief W09, W10)
    Get-XrmPrivileges, New-XrmRolePrivilege -EntityLogicalName -AccessRight -ClampDepth, Get-XrmRolePrivileges (EntityLogicalName, AccessRight),
    Get-XrmRoles -Name, Get-XrmUser -Email, Get-XrmUserPrivileges, Test-XrmUserPrivilege.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# Get-XrmPrivileges
# ============================================================
Write-Section "Get-XrmPrivileges";

$readAccount = @(Get-XrmPrivileges -XrmClient $Global:XrmClient -Name "prvReadAccount");
Assert-Test "prvReadAccount: account, Read, four depths" {
    $readAccount.Count -eq 1 -and $readAccount[0].EntityLogicalName -eq "account" -and $readAccount[0].AccessRight -eq "Read" -and $readAccount[0].AccessRightValue -eq 1 -and $readAccount[0].SupportedDepths.Count -eq 4;
};

$writeAccount = @(Get-XrmPrivileges -XrmClient $Global:XrmClient -EntityLogicalName "account" -AccessRight Write);
Assert-Test "-EntityLogicalName account -AccessRight Write: prvWriteAccount" { $writeAccount.Count -eq 1 -and $writeAccount[0].Name -eq "prvWriteAccount" };

$bypass = @(Get-XrmPrivileges -XrmClient $Global:XrmClient -Name "prvBypassCustomPlugins");
Assert-Test "prvBypassCustomPlugins: no table, AccessRight None, Global only" {
    $bypass.Count -eq 1 -and $null -eq $bypass[0].EntityLogicalName -and $bypass[0].AccessRight -eq "None" -and @($bypass[0].SupportedDepths).Count -eq 1 -and $bypass[0].SupportedDepths[0] -eq [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Global;
};

$readActivity = @(Get-XrmPrivileges -XrmClient $Global:XrmClient -Name "prvReadActivity");
Assert-Test "prvReadActivity: several tables in EntityLogicalNames (email included)" { $readActivity.Count -eq 1 -and $readActivity[0].EntityLogicalNames.Count -gt 1 -and $readActivity[0].EntityLogicalNames -contains "email" };

# ============================================================
# New-XrmRolePrivilege
# ============================================================
Write-Section "New-XrmRolePrivilege";

$byTable = New-XrmRolePrivilege -XrmClient $Global:XrmClient -EntityLogicalName "account" -AccessRight Read -Depth Local;
Assert-Test "-EntityLogicalName -AccessRight: prvReadAccount, depth kept" { $byTable.PrivilegeId -eq $readAccount[0].Id -and $byTable.PrivilegeName -eq "prvReadAccount" -and $byTable.Depth -eq [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Local };

$clampedUp = New-XrmRolePrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvBypassCustomPlugins" -Depth Basic -ClampDepth;
Assert-Test "-ClampDepth: Basic on a Global-only privilege => Global" { $clampedUp.Depth -eq [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Global };

$notClamped = New-XrmRolePrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvBypassCustomPlugins" -Depth Basic;
Assert-Test "Without -ClampDepth: depth kept as given" { $notClamped.Depth -eq [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Basic };

$limitedQuery = New-XrmQueryExpression -LogicalName "privilege" -Columns "name" -TopCount 1;
$limitedQuery = $limitedQuery | Add-XrmQueryCondition -Field "canbeglobal" -Condition Equal -Values $false;
$limitedQuery = $limitedQuery | Add-XrmQueryCondition -Field "canbebasic" -Condition Equal -Values $true;
$limited = @($Global:XrmClient | Get-XrmMultipleRecords -Query $limitedQuery) | Select-Object -First 1;
if ($limited) {
    $limitedDefinition = Get-XrmPrivileges -XrmClient $Global:XrmClient -Name $limited.name;
    $clampedDown = New-XrmRolePrivilege -XrmClient $Global:XrmClient -PrivilegeName $limited.name -Depth Global -ClampDepth;
    $expectedDepth = $limitedDefinition.SupportedDepths | Sort-Object { [int]$_ } | Select-Object -Last 1;
    Assert-Test "-ClampDepth: Global on '$($limited.name)' => highest supported ($expectedDepth)" { $clampedDown.Depth -eq $expectedDepth };
}
else {
    Write-Host "  [SKIP] No privilege without Global depth" -ForegroundColor Yellow;
}

$pairError = $null;
try { New-XrmRolePrivilege -XrmClient $Global:XrmClient -EntityLogicalName "account" -Depth Global | Out-Null; } catch { $pairError = $_.Exception.Message; }
Assert-Test "-EntityLogicalName without -AccessRight: error" { $pairError -like "*go together*" };

$unknownError = $null;
try { New-XrmRolePrivilege -XrmClient $Global:XrmClient -EntityLogicalName "pdo_nosuchtable" -AccessRight Read -Depth Global | Out-Null; } catch { $unknownError = $_.Exception.Message; }
Assert-Test "Unknown table: error naming it" { $unknownError -like "*pdo_nosuchtable*not found*" };

# ============================================================
# Get-XrmRolePrivileges / Get-XrmRoles -Name
# ============================================================
Write-Section "Get-XrmRolePrivileges";

$roleName = Get-TestName -Prefix "PdoPrivileges";
$roleRef = Add-XrmSecurityRole -XrmClient $Global:XrmClient -Name $roleName -Description "Integration test role";
Add-XrmSecurityRolePrivileges -XrmClient $Global:XrmClient -RoleReference $roleRef -Privileges @($byTable, $clampedUp) | Out-Null;
$rolePrivileges = @(Get-XrmRolePrivileges -XrmClient $Global:XrmClient -RoleId $roleRef.Id);
$readEntry = $rolePrivileges | Where-Object { $_.PrivilegeName -eq "prvReadAccount" };
$bypassEntry = $rolePrivileges | Where-Object { $_.PrivilegeName -eq "prvBypassCustomPlugins" };
# A new role also receives a few default privileges (prvReadSdkMessage...)
Assert-Test "Both privileges found, every entry named and described" {
    $null -ne $readEntry -and $null -ne $bypassEntry -and @($rolePrivileges | Where-Object { -not $_.PrivilegeName -or -not $_.AccessRight }).Count -eq 0;
};
Assert-Test "prvReadAccount entry: EntityLogicalName account, AccessRight Read, depth Local" { $readEntry.EntityLogicalName -eq "account" -and $readEntry.AccessRight -eq "Read" -and $readEntry.Depth -eq [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Local };
Assert-Test "prvBypassCustomPlugins entry: AccessRight None, no table" { $bypassEntry.AccessRight -eq "None" -and $null -eq $bypassEntry.EntityLogicalName };

Write-Section "Get-XrmRoles -Name";
$byName = @(Get-XrmRoles -XrmClient $Global:XrmClient -Name $roleName);
Assert-Test "-Name (exact): the test role" { $byName.Count -eq 1 -and $byName[0].Id -eq $roleRef.Id };
$byPattern = @(Get-XrmRoles -XrmClient $Global:XrmClient -Name "$($roleName.Substring(0, 20))*");
Assert-Test "-Name (wildcard): the test role, every row matches" { @($byPattern | Where-Object { $_.Id -eq $roleRef.Id }).Count -eq 1 -and @($byPattern | Where-Object { $_.name -notlike "$($roleName.Substring(0, 20))*" }).Count -eq 0 };

Remove-XrmSecurityRole -XrmClient $Global:XrmClient -RoleReference $roleRef;

# ============================================================
# Get-XrmUser -Email
# ============================================================
Write-Section "Get-XrmUser -Email";

$me = Get-XrmUser -XrmClient $Global:XrmClient -Columns "fullname", "internalemailaddress";
if ($me.internalemailaddress) {
    $byEmail = Get-XrmUser -XrmClient $Global:XrmClient -Email $me.internalemailaddress -Columns "fullname";
    Assert-Test "-Email: current user found by address" { $byEmail.Id -eq $me.Id };
}
else {
    Write-Host "  [SKIP] Current user has no primary email" -ForegroundColor Yellow;
}
Assert-Test "-Email unknown: `$null" { $null -eq (Get-XrmUser -XrmClient $Global:XrmClient -Email "pdo-nobody-$(Get-Random)@example.com") };
$bothError = $null;
try { Get-XrmUser -XrmClient $Global:XrmClient -UserId $me.Id -Email "x@example.com" | Out-Null; } catch { $bothError = $_.Exception.Message; }
Assert-Test "-UserId with -Email: error" { $bothError -like "*either UserId or Email*" };

# ============================================================
# Get-XrmUserPrivileges / Test-XrmUserPrivilege
# ============================================================
Write-Section "Get-XrmUserPrivileges / Test-XrmUserPrivilege";

$myPrivileges = @(Get-XrmUserPrivileges -XrmClient $Global:XrmClient);
$myReadAccount = $myPrivileges | Where-Object { $_.PrivilegeName -eq "prvReadAccount" } | Select-Object -First 1;
Assert-Test "Current user: privileges returned, names filled (actual: $($myPrivileges.Count))" { $myPrivileges.Count -gt 0 -and @($myPrivileges | Where-Object { -not $_.PrivilegeName }).Count -eq 0 };
Assert-Test "Current user: prvReadAccount with EntityLogicalName and AccessRight" { $myReadAccount.EntityLogicalName -eq "account" -and $myReadAccount.AccessRight -eq "Read" };

Assert-Test "Test-XrmUserPrivilege prvReadAccount: true" { Test-XrmUserPrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvReadAccount" };
$myBypass = @($myPrivileges | Where-Object { $_.PrivilegeName -eq "prvBypassCustomPlugins" }).Count -gt 0;
Assert-Test "Test-XrmUserPrivilege prvBypassCustomPlugins matches Get-XrmUserPrivileges ($myBypass)" { (Test-XrmUserPrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvBypassCustomPlugins") -eq $myBypass };
$maxDepth = $myPrivileges | Where-Object { $_.PrivilegeName -eq "prvReadAccount" } | ForEach-Object { [int]$_.Depth } | Sort-Object | Select-Object -Last 1;
Assert-Test "-Depth: true up to the held depth, false above" {
    (Test-XrmUserPrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvReadAccount" -Depth ([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]$maxDepth)) -and
    ($maxDepth -eq 3 -or -not (Test-XrmUserPrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvReadAccount" -Depth ([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]($maxDepth + 1))));
};

$privilegeError = $null;
try { Test-XrmUserPrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvPdoNoSuchPrivilege" | Out-Null; } catch { $privilegeError = $_.Exception.Message; }
Assert-Test "Unknown privilege: error" { $privilegeError -like "*prvPdoNoSuchPrivilege*" };

# A user without direct role: both cmdlets must agree
$usersQuery = New-XrmQueryExpression -LogicalName "systemuser" -Columns "fullname" | Add-XrmQueryCondition -Field "isdisabled" -Condition Equal -Values $false;
$enabledUsers = @($Global:XrmClient | Get-XrmMultipleRecords -Query $usersQuery);
$rolesQuery = New-XrmQueryExpression -LogicalName "systemuserroles" -Columns "systemuserid";
$usersWithRole = @($Global:XrmClient | Get-XrmMultipleRecords -Query $rolesQuery -AsEntity) | ForEach-Object { $_["systemuserid"] };
$roleless = $enabledUsers | Where-Object { $usersWithRole -notcontains $_.Id } | Select-Object -First 1;
if ($roleless) {
    $rolelessHasRead = @(Get-XrmUserPrivileges -XrmClient $Global:XrmClient -UserId $roleless.Id | Where-Object { $_.PrivilegeName -eq "prvReadAccount" }).Count -gt 0;
    Assert-Test "User without direct role: Test-XrmUserPrivilege matches Get-XrmUserPrivileges ($rolelessHasRead)" { (Test-XrmUserPrivilege -XrmClient $Global:XrmClient -PrivilegeName "prvReadAccount" -UserId $roleless.Id) -eq $rolelessHasRead };
}
else {
    Write-Host "  [SKIP] No enabled user without role" -ForegroundColor Yellow;
}

Write-TestSummary;

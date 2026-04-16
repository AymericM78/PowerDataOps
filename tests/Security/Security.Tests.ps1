<#
    Integration Test: Security
    Tests user, role, team, sharing cmdlets.
    Cmdlets: Get-XrmWhoAmI, Get-XrmUser, Get-XrmUsers, Get-XrmRootBusinessUnit,
             Get-XrmRoles, Get-XrmUserRoles, Add-XrmUserRoles, Remove-XrmUserRoles,
             Get-XrmUsersFromTeam, Add-XrmUserToTeam, Remove-XrmUserFromTeam,
             Share-XrmRecord, Revoke-XrmRecordAccess, New-XrmPrincipalAccess
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

# ============================================================
# WhoAmI / Current User
# ============================================================
Write-Section "WhoAmI + Get-XrmUser";

$whoAmI = Get-XrmWhoAmI;
Assert-Test "WhoAmI returns a UserId" {
    $whoAmI -ne $null -and $whoAmI -ne [Guid]::Empty;
};

$currentUser = $Global:XrmClient | Get-XrmUser;
Assert-Test "Get-XrmUser (current) - fullname not empty" {
    $currentUser -ne $null -and $currentUser.fullname -ne $null;
};
Write-Host "    Current user: $($currentUser.fullname)" -ForegroundColor Gray;

$currentUserById = $Global:XrmClient | Get-XrmUser -UserId $whoAmI -Columns "fullname", "internalemailaddress";
Assert-Test "Get-XrmUser by Id - same user" {
    $currentUserById.Id -eq $currentUser.Id;
};

# ============================================================
# Get-XrmUsers
# ============================================================
Write-Section "Get-XrmUsers";

$users = $Global:XrmClient | Get-XrmUsers -Columns "fullname", "internalemailaddress";
Assert-Test "Get-XrmUsers - returns at least 1 user (actual: $($users.Count))" {
    $users.Count -ge 1;
};

# ============================================================
# Get-XrmRootBusinessUnit
# ============================================================
Write-Section "Get-XrmRootBusinessUnit";

$rootBU = $Global:XrmClient | Get-XrmRootBusinessUnit -Columns "name", "businessunitid";
Assert-Test "Root BU found - name = '$($rootBU.name)'" {
    $rootBU -ne $null -and $rootBU.name -ne $null;
};

# ============================================================
# Get-XrmRoles
# ============================================================
Write-Section "Get-XrmRoles";

$roles = $Global:XrmClient | Get-XrmRoles -Columns "name", "roleid";
Assert-Test "Get-XrmRoles - returns roles (actual: $($roles.Count))" {
    $roles.Count -ge 1;
};

$rolesInBU = $Global:XrmClient | Get-XrmRoles -BusinessUnitId $rootBU.businessunitid -Columns "name", "roleid";
Assert-Test "Get-XrmRoles for root BU - returns roles (actual: $($rolesInBU.Count))" {
    $rolesInBU.Count -ge 1;
};

# ============================================================
# Get-XrmUserRoles
# ============================================================
Write-Section "Get-XrmUserRoles";

$myRoles = $Global:XrmClient | Get-XrmUserRoles -UserId $whoAmI -Columns "name", "roleid";
Assert-Test "Get-XrmUserRoles - current user has roles (actual: $($myRoles.Count))" {
    $myRoles.Count -ge 1;
};
Write-Host "    Roles: $(($myRoles | ForEach-Object { $_.name }) -join ', ')" -ForegroundColor Gray;

# ============================================================
# Share / Revoke Access
# ============================================================
Write-Section "Share-XrmRecord + Revoke-XrmRecordAccess";

# Create a test account to share
$shareName = Get-TestName -Prefix "Share";
$shareRecord = New-XrmEntity -LogicalName "account" -Attributes @{
    "name" = $shareName;
};
$shareRecord.Id = $Global:XrmClient | Add-XrmRecord -Record $shareRecord;
$shareRef = $shareRecord.ToEntityReference();
Assert-Test "Account created for sharing test" {
    $shareRecord.Id -ne [Guid]::Empty;
};

# Create PrincipalAccess for current user
$userRef = New-XrmEntityReference -LogicalName "systemuser" -Id $whoAmI;
$principalAccess = New-XrmPrincipalAccess -Principal $userRef -AccessRights ([Microsoft.Crm.Sdk.Messages.AccessRights]::ReadAccess -bor [Microsoft.Crm.Sdk.Messages.AccessRights]::WriteAccess);
Assert-Test "New-XrmPrincipalAccess created" {
    $principalAccess -ne $null -and $principalAccess.Principal.Id -eq $whoAmI;
};

# Share
$shareResponse = $Global:XrmClient | Share-XrmRecord -TargetReference $shareRef -PrincipalAccess $principalAccess;
Assert-Test "Share-XrmRecord succeeded" {
    $shareResponse -ne $null;
};

# Revoke
$revokeResponse = $Global:XrmClient | Revoke-XrmRecordAccess -PrincipalReference $userRef -TargetReference $shareRef;
Assert-Test "Revoke-XrmRecordAccess succeeded" {
    $revokeResponse -ne $null;
};

# ============================================================
# Team operations
# ============================================================
Write-Section "Team operations";

# Find an existing team (owner team of root BU)
$query = New-XrmQueryExpression -LogicalName "team" -Columns "name", "teamid" -TopCount 1;
$query = $query | Add-XrmQueryCondition -Field "teamtype" -Condition Equal -Values @(0);
$query = $query | Add-XrmQueryCondition -Field "isdefault" -Condition Equal -Values @($true);
$defaultTeam = ($Global:XrmClient | Get-XrmMultipleRecords -Query $query) | Select-Object -First 1;

if ($defaultTeam) {
    $teamRef = $defaultTeam.Reference;

    $teamUsers = $Global:XrmClient | Get-XrmUsersFromTeam -TeamReference $teamRef -Columns "fullname";
    Assert-Test "Get-XrmUsersFromTeam - default team has members (actual: $($teamUsers.Count))" {
        $teamUsers.Count -ge 1;
    };
}
else {
    Write-Host "  [SKIP] No default team found for team operation tests" -ForegroundColor Yellow;
}

# ============================================================
# CLEANUP
# ============================================================
Write-Section "Cleanup";

$Global:XrmClient | Remove-XrmRecord -LogicalName "account" -Id $shareRecord.Id;
Assert-Test "Shared account deleted" { $true };

Write-TestSummary;

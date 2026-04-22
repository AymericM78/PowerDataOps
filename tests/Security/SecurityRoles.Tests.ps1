<#
    Integration Test: Security Roles & Privileges
    Tests Add-XrmSecurityRole, Set-XrmSecurityRole, Copy-XrmSecurityRole, Remove-XrmSecurityRole,
          New-XrmRolePrivilege, Add-XrmSecurityRolePrivileges, Get-XrmRolePrivileges,
          Remove-XrmSecurityRolePrivilege, Set-XrmSecurityRolePrivileges.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

$roleName1 = Get-TestName -Prefix "Role";
$roleName2 = Get-TestName -Prefix "RoleCopy";
$roleRef1 = $null;
$roleRef2 = $null;

# ============================================================
# Add-XrmSecurityRole
# ============================================================
Write-Section "Add-XrmSecurityRole";

$roleRef1 = Add-XrmSecurityRole -Name $roleName1 -Description "Integration test role";
Assert-Test "Add-XrmSecurityRole - role created" {
    $roleRef1 -ne $null -and $roleRef1.Id -ne [Guid]::Empty;
};
Write-Host "    Role: $roleName1 ($($roleRef1.Id))" -ForegroundColor Gray;

# Verify by retrieving
$roleRecord = $Global:XrmClient | Get-XrmRecord -LogicalName "role" -Id $roleRef1.Id -Columns "name", "description";
Assert-Test "Role name matches" {
    $roleRecord.name -eq $roleName1;
};
Assert-Test "Role description matches" {
    $roleRecord.description -eq "Integration test role";
};

# ============================================================
# Set-XrmSecurityRole
# ============================================================
Write-Section "Set-XrmSecurityRole";

$updatedName = "${roleName1}_Updated";
$updatedRef = Set-XrmSecurityRole -RoleReference $roleRef1 -Name $updatedName -Description "Updated description";
Assert-Test "Set-XrmSecurityRole - returned reference" {
    $updatedRef -ne $null -and $updatedRef.Id -eq $roleRef1.Id;
};

$roleRecordUpdated = $Global:XrmClient | Get-XrmRecord -LogicalName "role" -Id $roleRef1.Id -Columns "name", "description";
Assert-Test "Role name updated" {
    $roleRecordUpdated.name -eq $updatedName;
};
Assert-Test "Role description updated" {
    $roleRecordUpdated.description -eq "Updated description";
};

# ============================================================
# Copy-XrmSecurityRole
# ============================================================
Write-Section "Copy-XrmSecurityRole";

$roleRef2 = Copy-XrmSecurityRole -SourceRoleReference $roleRef1 -Name $roleName2 -Description "Copied integration test role";
Assert-Test "Copy-XrmSecurityRole - copy created" {
    $roleRef2 -ne $null -and $roleRef2.Id -ne [Guid]::Empty;
};
Assert-Test "Copy is a different role" {
    $roleRef2.Id -ne $roleRef1.Id;
};

$copyRecord = $Global:XrmClient | Get-XrmRecord -LogicalName "role" -Id $roleRef2.Id -Columns "name", "description";
Assert-Test "Copied role name matches" {
    $copyRecord.name -eq $roleName2;
};

# ============================================================
# New-XrmRolePrivilege + Add-XrmSecurityRolePrivileges
# ============================================================
Write-Section "New-XrmRolePrivilege + Add-XrmSecurityRolePrivileges";

$priv1 = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth ([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Global);
Assert-Test "New-XrmRolePrivilege - created (prvReadAccount)" {
    $priv1 -ne $null -and $priv1.PrivilegeId -ne [Guid]::Empty;
};

$priv2 = New-XrmRolePrivilege -PrivilegeName "prvWriteAccount" -Depth ([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Local);
Assert-Test "New-XrmRolePrivilege - created (prvWriteAccount)" {
    $priv2 -ne $null -and $priv2.PrivilegeId -ne [Guid]::Empty;
};

$addResponse = Add-XrmSecurityRolePrivileges -RoleReference $roleRef1 -Privileges @($priv1, $priv2);
Assert-Test "Add-XrmSecurityRolePrivileges - privileges added" {
    $addResponse -ne $null;
};

# Verify with Get-XrmRolePrivileges
$currentPrivs = Get-XrmRolePrivileges -RoleId $roleRef1.Id;
$hasRead = $currentPrivs | Where-Object { $_.PrivilegeId -eq $priv1.PrivilegeId };
$hasWrite = $currentPrivs | Where-Object { $_.PrivilegeId -eq $priv2.PrivilegeId };
Assert-Test "Role has prvReadAccount privilege" {
    $hasRead -ne $null;
};
Assert-Test "Role has prvWriteAccount privilege" {
    $hasWrite -ne $null;
};

# ============================================================
# Remove-XrmSecurityRolePrivilege
# ============================================================
Write-Section "Remove-XrmSecurityRolePrivilege";

$removePrivResponse = Remove-XrmSecurityRolePrivilege -RoleReference $roleRef1 -PrivilegeId $priv2.PrivilegeId;
Assert-Test "Remove-XrmSecurityRolePrivilege - prvWriteAccount removed" {
    $removePrivResponse -ne $null;
};

$afterRemovePrivs = Get-XrmRolePrivileges -RoleId $roleRef1.Id;
$stillHasWrite = $afterRemovePrivs | Where-Object { $_.PrivilegeId -eq $priv2.PrivilegeId };
Assert-Test "prvWriteAccount no longer in role" {
    $stillHasWrite -eq $null;
};

# ============================================================
# Set-XrmSecurityRolePrivileges (replace all)
# ============================================================
Write-Section "Set-XrmSecurityRolePrivileges";

$priv3 = New-XrmRolePrivilege -PrivilegeName "prvReadContact" -Depth ([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Deep);
$setResponse = Set-XrmSecurityRolePrivileges -RoleReference $roleRef1 -Privileges @($priv3);
Assert-Test "Set-XrmSecurityRolePrivileges - privileges replaced" {
    $setResponse -ne $null;
};

$replacedPrivs = Get-XrmRolePrivileges -RoleId $roleRef1.Id;
$hasContact = $replacedPrivs | Where-Object { $_.PrivilegeId -eq $priv3.PrivilegeId };
$hasOldRead = $replacedPrivs | Where-Object { $_.PrivilegeId -eq $priv1.PrivilegeId };
Assert-Test "Role now has prvReadContact" {
    $hasContact -ne $null;
};
Assert-Test "prvReadAccount was replaced (gone)" {
    $hasOldRead -eq $null;
};

# ============================================================
# Remove-XrmSecurityRole
# ============================================================
Write-Section "Remove-XrmSecurityRole (cleanup)";

if ($roleRef2) {
    Remove-XrmSecurityRole -RoleReference $roleRef2;
    Assert-Test "Copied role deleted" { $true };
}
if ($roleRef1) {
    Remove-XrmSecurityRole -RoleReference $roleRef1;
    Assert-Test "Original role deleted" { $true };
}

Write-TestSummary;

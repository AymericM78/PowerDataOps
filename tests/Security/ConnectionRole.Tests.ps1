<#!
    Integration Test: ConnectionRole cmdlets
    Validates create, get, and remove connection roles.
#>
. "$PSScriptRoot\..\_TestConfig.ps1";

Write-Section "Create ConnectionRole";
$name = Get-TestName -Prefix "ConnRole";
$role = New-XrmConnectionRole -Name $name;
Assert-Test "Role created" { $role -and $role.connectionroleid };

Write-Section "Get ConnectionRoles";
$roles = Get-XrmConnectionRoles -Name $name;
Assert-Test "Role found" { $roles.Count -eq 1 -and $roles[0].connectionroleid -eq $role.connectionroleid };

Write-Section "Remove ConnectionRole";
Remove-XrmConnectionRole -ConnectionRoleId $role.connectionroleid | Out-Null;
$gone = Get-XrmConnectionRoles -Name $name;
Assert-Test "Role removed" { $gone.Count -eq 0 };

Write-TestSummary;

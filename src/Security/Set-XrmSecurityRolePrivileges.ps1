<#
    .SYNOPSIS
    Replace all privileges on a security role.

    .DESCRIPTION
    Replace the entire privilege set of an existing security role using the ReplacePrivilegesRole SDK message.
    This removes all current privileges and sets only the ones provided.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RoleReference
    Entity reference of the security role.

    .PARAMETER Privileges
    Array of RolePrivilege objects that will replace all existing privileges. Use New-XrmRolePrivilege to create them.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The ReplacePrivilegesRole response.

    .EXAMPLE
    $roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
    $priv1 = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
    $priv2 = New-XrmRolePrivilege -PrivilegeName "prvWriteAccount" -Depth Local;
    Set-XrmSecurityRolePrivileges -RoleReference $roleRef -Privileges @($priv1, $priv2);

    .EXAMPLE
    $sourcePrivileges = Get-XrmRolePrivileges -RoleId $sourceRoleId;
    Set-XrmSecurityRolePrivileges -RoleReference $targetRoleRef -Privileges $sourcePrivileges;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/replaceprivilegesrole
#>
function Set-XrmSecurityRolePrivileges {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $RoleReference,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Crm.Sdk.Messages.RolePrivilege[]]
        $Privileges
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "ReplacePrivilegesRole";
        $request = $request | Add-XrmRequestParameter -Name "RoleId" -Value $RoleReference.Id;
        $request = $request | Add-XrmRequestParameter -Name "Privileges" -Value $Privileges;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmSecurityRolePrivileges -Alias *;

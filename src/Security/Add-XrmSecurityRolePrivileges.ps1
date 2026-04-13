<#
    .SYNOPSIS
    Add privileges to a security role.

    .DESCRIPTION
    Add one or more privileges to an existing security role using the AddPrivilegesRole SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RoleReference
    Entity reference of the security role.

    .PARAMETER Privileges
    Array of RolePrivilege objects to add to the role. Use New-XrmRolePrivilege to create them.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The AddPrivilegesRole response.

    .EXAMPLE
    $roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
    $priv1 = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;
    $priv2 = New-XrmRolePrivilege -PrivilegeName "prvWriteAccount" -Depth Local;
    Add-XrmSecurityRolePrivileges -RoleReference $roleRef -Privileges @($priv1, $priv2);

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/addprivilegesrole
#>
function Add-XrmSecurityRolePrivileges {
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
        $request = New-XrmRequest -Name "AddPrivilegesRole";
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

Export-ModuleMember -Function Add-XrmSecurityRolePrivileges -Alias *;

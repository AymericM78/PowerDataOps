<#
    .SYNOPSIS
    Remove a privilege from a security role.

    .DESCRIPTION
    Remove a single privilege from an existing security role using the RemovePrivilegeRole SDK message.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RoleReference
    Entity reference of the security role.

    .PARAMETER PrivilegeId
    Unique identifier of the privilege to remove.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The RemovePrivilegeRole response.

    .EXAMPLE
    $roleRef = New-XrmEntityReference -LogicalName "role" -Id $roleId;
    Remove-XrmSecurityRolePrivilege -RoleReference $roleRef -PrivilegeId $privilegeId;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/removeprivilegerole
#>
function Remove-XrmSecurityRolePrivilege {
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
        [ValidateNotNullOrEmpty()]
        [Guid]
        $PrivilegeId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "RemovePrivilegeRole";
        $request = $request | Add-XrmRequestParameter -Name "RoleId" -Value $RoleReference.Id;
        $request = $request | Add-XrmRequestParameter -Name "PrivilegeId" -Value $PrivilegeId;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Remove-XrmSecurityRolePrivilege -Alias *;

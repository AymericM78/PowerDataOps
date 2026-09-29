<#
    .SYNOPSIS
    Retrieve the privileges of a user.

    .DESCRIPTION
    Get the privileges a user holds through their security roles (RetrieveUserPrivileges): one RolePrivilege per privilege and depth.
    Each RolePrivilege also carries EntityLogicalName and AccessRight (see Get-XrmPrivileges), and its PrivilegeName is filled when the platform leaves it empty.
    To check a single privilege, Test-XrmUserPrivilege is cheaper.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UserId
    System user unique identifier. (Default: current user)

    .OUTPUTS
    Microsoft.Crm.Sdk.Messages.RolePrivilege[]. Privileges of the user, with the EntityLogicalName and AccessRight note properties.

    .EXAMPLE
    $privileges = Get-XrmUserPrivileges -XrmClient $xrmClient -UserId $user.Id;
    $privileges | Where-Object { $_.EntityLogicalName -eq "account" } | Select-Object PrivilegeName, AccessRight, Depth;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUserPrivileges.md
#>
function Get-XrmUserPrivileges {
    [CmdletBinding()]
    [OutputType([Microsoft.Crm.Sdk.Messages.RolePrivilege[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $UserId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('UserId')) {
            $UserId = Get-XrmWhoAmI -XrmClient $XrmClient;
        }

        $request = New-XrmRequest -Name "RetrieveUserPrivileges";
        $request = $request | Add-XrmRequestParameter -Name "UserId" -Value $UserId;
        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        if ($null -eq $response) {
            return;
        }
        $privileges = @($response.Results["RolePrivileges"]);
        if ($privileges.Count -eq 0) {
            return;
        }

        # Names, tables and access rights: by id when they are few, else every privilege in one read
        $privilegeIds = @($privileges | ForEach-Object { $_.PrivilegeId } | Select-Object -Unique);
        $privilegeInfos = @{};
        $definitions = $(if ($privilegeIds.Count -le 500) { Get-XrmPrivileges -XrmClient $XrmClient -Id $privilegeIds } else { Get-XrmPrivileges -XrmClient $XrmClient });
        foreach ($privilegeInfo in $definitions) {
            $privilegeInfos[$privilegeInfo.Id] = $privilegeInfo;
        }
        foreach ($privilege in $privileges) {
            $privilegeInfo = $privilegeInfos[$privilege.PrivilegeId];
            if ($privilegeInfo -and -not $privilege.PrivilegeName) {
                $privilege.PrivilegeName = $privilegeInfo.Name;
            }
            $privilege | Add-Member -MemberType NoteProperty -Name "EntityLogicalName" -Value $privilegeInfo.EntityLogicalName -Force;
            $privilege | Add-Member -MemberType NoteProperty -Name "AccessRight" -Value $privilegeInfo.AccessRight -Force;
        }
        $privileges;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmUserPrivileges -Alias *;

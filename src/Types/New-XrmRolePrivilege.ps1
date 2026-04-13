<#
    .SYNOPSIS
    Create a RolePrivilege object.

    .DESCRIPTION
    Instantiate a RolePrivilege object used to define a privilege with its depth for security role operations.

    .PARAMETER PrivilegeId
    Unique identifier of the privilege.

    .PARAMETER PrivilegeName
    Name of the privilege (e.g. "prvReadAccount"). Used to resolve the PrivilegeId automatically if PrivilegeId is not provided.

    .PARAMETER Depth
    Depth of the privilege (Basic, Local, Deep, Global).

    .PARAMETER BusinessUnitId
    Business unit unique identifier. Optional, defaults to Guid.Empty.

    .OUTPUTS
    Microsoft.Crm.Sdk.Messages.RolePrivilege. The constructed RolePrivilege object.

    .EXAMPLE
    $priv = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;

    .EXAMPLE
    $priv = New-XrmRolePrivilege -PrivilegeId $privilegeId -Depth Local;

    .LINK
    https://learn.microsoft.com/en-us/dotnet/api/microsoft.crm.sdk.messages.roleprivilege
#>
function New-XrmRolePrivilege {
    [CmdletBinding()]
    [OutputType([Microsoft.Crm.Sdk.Messages.RolePrivilege])]
    param
    (
        [Parameter(Mandatory = $false)]
        [Guid]
        $PrivilegeId,

        [Parameter(Mandatory = $false)]
        [string]
        $PrivilegeName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Crm.Sdk.Messages.PrivilegeDepth]
        $Depth,

        [Parameter(Mandatory = $false)]
        [Guid]
        $BusinessUnitId = [Guid]::Empty
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('PrivilegeId') -and -not $PSBoundParameters.ContainsKey('PrivilegeName')) {
            throw "You must provide either PrivilegeId or PrivilegeName.";
        }

        $resolvedId = $PrivilegeId;
        $resolvedName = $PrivilegeName;

        if (-not $PSBoundParameters.ContainsKey('PrivilegeId')) {
            # Resolve PrivilegeId from PrivilegeName
            $query = New-XrmQueryExpression -LogicalName "privilege" -Columns "privilegeid", "name" -TopCount 1;
            $query = $query | Add-XrmQueryCondition -Field "name" -Condition Equal -Values @($PrivilegeName);
            $results = Get-XrmMultipleRecords -Query $query;
            $privRecord = $results | Select-Object -First 1;
            if (-not $privRecord) {
                throw "Privilege '$PrivilegeName' not found.";
            }
            $resolvedId = $privRecord.privilegeid;
        }

        $rolePrivilege = [Microsoft.Crm.Sdk.Messages.RolePrivilege]::new($Depth, $resolvedId, $BusinessUnitId);
        if ($resolvedName) {
            $rolePrivilege.PrivilegeName = $resolvedName;
        }
        $rolePrivilege;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmRolePrivilege -Alias *;

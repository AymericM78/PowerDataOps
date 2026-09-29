<#
    .SYNOPSIS
    Create a RolePrivilege object.

    .DESCRIPTION
    Instantiate a RolePrivilege object used to define a privilege with its depth for security role operations.
    The privilege is given by PrivilegeId, by PrivilegeName, or by EntityLogicalName + AccessRight (e.g. account + Write => prvWriteAccount).
    With ClampDepth, a depth the privilege does not support is replaced by the closest supported one: the highest supported depth below the requested one, else the lowest above it (e.g. Global only for organization-owned tables).

    .PARAMETER PrivilegeId
    Unique identifier of the privilege.

    .PARAMETER PrivilegeName
    Name of the privilege (e.g. "prvReadAccount"). Used to resolve the PrivilegeId automatically if PrivilegeId is not provided.

    .PARAMETER Depth
    Depth of the privilege (Basic, Local, Deep, Global).

    .PARAMETER BusinessUnitId
    Business unit unique identifier. Optional, defaults to Guid.Empty.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance, used to resolve PrivilegeName. Use latest one by default. (Dataverse ServiceClient)
    Declared last to keep the existing positional parameters.

    .PARAMETER EntityLogicalName
    Table of the privilege, with AccessRight, instead of PrivilegeId or PrivilegeName.

    .PARAMETER AccessRight
    Access right of the privilege, with EntityLogicalName: Read, Write, Create, Delete, Append, AppendTo, Assign, Share.

    .PARAMETER ClampDepth
    Replace a depth the privilege does not support by the closest supported one, instead of keeping it as given.

    .OUTPUTS
    Microsoft.Crm.Sdk.Messages.RolePrivilege. The constructed RolePrivilege object.

    .EXAMPLE
    $priv = New-XrmRolePrivilege -PrivilegeName "prvReadAccount" -Depth Global;

    .EXAMPLE
    $priv = New-XrmRolePrivilege -PrivilegeId $privilegeId -Depth Local;

    .EXAMPLE
    # Local where the table supports it, Global for organization-owned tables
    $privileges = "account", "businessunit" | ForEach-Object { New-XrmRolePrivilege -XrmClient $xrmClient -EntityLogicalName $_ -AccessRight Read -Depth Local -ClampDepth };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmRolePrivilege.md
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
        $BusinessUnitId = [Guid]::Empty,

        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Read", "Write", "Create", "Delete", "Append", "AppendTo", "Assign", "Share")]
        [string]
        $AccessRight,

        [Parameter(Mandatory = $false)]
        [switch]
        $ClampDepth
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $byId = $PSBoundParameters.ContainsKey('PrivilegeId');
        $byName = $PSBoundParameters.ContainsKey('PrivilegeName');
        $byTable = $PSBoundParameters.ContainsKey('EntityLogicalName') -or $PSBoundParameters.ContainsKey('AccessRight');
        if (-not $byId -and -not $byName -and -not $byTable) {
            throw "You must provide either PrivilegeId, PrivilegeName, or EntityLogicalName and AccessRight.";
        }
        if ($byTable -and -not ($PSBoundParameters.ContainsKey('EntityLogicalName') -and $PSBoundParameters.ContainsKey('AccessRight'))) {
            throw "EntityLogicalName and AccessRight go together.";
        }

        $resolvedId = $PrivilegeId;
        $resolvedName = $PrivilegeName;
        $resolvedDepth = $Depth;

        # The privilege definition is read for a table + access right, or to know the supported depths
        $needsDefinition = $ClampDepth -or (-not $byId -and -not $byName);
        if (-not $needsDefinition -and -not $byId) {
            # Resolve PrivilegeId from PrivilegeName
            $query = New-XrmQueryExpression -LogicalName "privilege" -Columns "privilegeid", "name" -TopCount 1;
            $query = $query | Add-XrmQueryCondition -Field "name" -Condition Equal -Values @($PrivilegeName);
            $results = $XrmClient | Get-XrmMultipleRecords -Query $query;
            $privRecord = $results | Select-Object -First 1;
            if (-not $privRecord) {
                throw "Privilege '$PrivilegeName' not found.";
            }
            $resolvedId = $privRecord.privilegeid;
        }
        elseif ($needsDefinition) {
            if ($byId) {
                $candidates = @(Get-XrmPrivileges -XrmClient $XrmClient -Id $PrivilegeId);
                $description = "Privilege '$PrivilegeId'";
            }
            elseif ($byName) {
                $candidates = @(Get-XrmPrivileges -XrmClient $XrmClient -Name $PrivilegeName);
                $description = "Privilege '$PrivilegeName'";
            }
            else {
                $candidates = @(Get-XrmPrivileges -XrmClient $XrmClient -EntityLogicalName $EntityLogicalName -AccessRight $AccessRight);
                $description = "$AccessRight privilege of table '$EntityLogicalName'";
            }
            if ($candidates.Count -eq 0) {
                throw "$description not found.";
            }
            if ($candidates.Count -gt 1) {
                throw "$description is ambiguous: $(($candidates | ForEach-Object { $_.Name }) -join ', ').";
            }
            $privilege = $candidates[0];
            $resolvedId = $privilege.Id;
            $resolvedName = $privilege.Name;

            if ($ClampDepth -and $privilege.SupportedDepths.Count -gt 0 -and $privilege.SupportedDepths -notcontains $Depth) {
                $lower = @($privilege.SupportedDepths | Where-Object { [int]$_ -lt [int]$Depth } | Sort-Object { [int]$_ });
                $upper = @($privilege.SupportedDepths | Where-Object { [int]$_ -gt [int]$Depth } | Sort-Object { [int]$_ });
                $resolvedDepth = $(if ($lower.Count -gt 0) { $lower[-1] } else { $upper[0] });
                Write-Verbose "$($privilege.Name): depth $Depth is not supported, $resolvedDepth used.";
            }
        }

        $rolePrivilege = [Microsoft.Crm.Sdk.Messages.RolePrivilege]::new($resolvedDepth, $resolvedId, $BusinessUnitId);
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

Register-ArgumentCompleter -CommandName New-XrmRolePrivilege -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

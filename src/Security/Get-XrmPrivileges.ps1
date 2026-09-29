<#
    .SYNOPSIS
    Retrieve privileges with their table, access right and supported depths.

    .DESCRIPTION
    Read privilege definitions (privilege table) and describe each one: Id, Name, AccessRight (Read, Write, Create, Delete, Append, AppendTo, Assign, Share, or None for the miscellaneous privileges such as prvBypassCustomPlugins), AccessRightValue, EntityLogicalName, EntityLogicalNames, CanBeBasic, CanBeLocal, CanBeDeep, CanBeGlobal, SupportedDepths.
    A privilege can cover several tables (prvReadActivity covers every activity table, prvReadAccount also covers customeraddress): EntityLogicalNames lists them all.
    EntityLogicalName is the table named after the privilege (prvReadAccount => account), the filtered table with -EntityLogicalName, the only table, or $null when none of these applies.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Privilege names (e.g. "prvReadAccount"). (Default: all)

    .PARAMETER Id
    Privilege unique identifiers. (Default: all)

    .PARAMETER EntityLogicalName
    Keep the privileges that apply to this table. (Default: all)

    .PARAMETER AccessRight
    Keep the privileges of this access right: Read, Write, Create, Delete, Append, AppendTo, Assign, Share. (Default: all)

    .PARAMETER RoleId
    Keep the privileges granted to this security role. (Default: all)

    .OUTPUTS
    PSCustomObject[]. One object per privilege.

    .EXAMPLE
    $privilege = Get-XrmPrivileges -XrmClient $xrmClient -EntityLogicalName "account" -AccessRight Write;   # prvWriteAccount

    .EXAMPLE
    Get-XrmPrivileges -XrmClient $xrmClient -Name "prvBypassCustomPlugins" | Select-Object Name, SupportedDepths;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPrivileges.md
#>
function Get-XrmPrivileges {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid[]]
        $Id,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Read", "Write", "Create", "Delete", "Append", "AppendTo", "Assign", "Share")]
        [String]
        $AccessRight,

        [Parameter(Mandatory = $false)]
        [Guid]
        $RoleId
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $accessRights = [ordered]@{ Read = 1; Write = 2; Append = 4; AppendTo = 16; Create = 32; Delete = 65536; Share = 262144; Assign = 524288 };

        $query = New-XrmQueryExpression -LogicalName "privilege" -Columns "name", "accessright", "canbebasic", "canbelocal", "canbedeep", "canbeglobal";
        if ($PSBoundParameters.ContainsKey('Name')) {
            $query = $query | Add-XrmQueryCondition -Field "name" -Condition In -Values $Name;
        }
        if ($PSBoundParameters.ContainsKey('Id')) {
            $query = $query | Add-XrmQueryCondition -Field "privilegeid" -Condition In -Values $Id;
        }
        if ($PSBoundParameters.ContainsKey('AccessRight')) {
            $query = $query | Add-XrmQueryCondition -Field "accessright" -Condition Equal -Values $accessRights[$AccessRight];
        }
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $entityLink = $query | Add-XrmQueryLink -ToEntityName "privilegeobjecttypecodes" -FromAttributeName "privilegeid" -ToAttributeName "privilegeid";
            $entityLink | Add-XrmQueryLinkCondition -Field "objecttypecode" -Condition Equal -Values $EntityLogicalName | Out-Null;
        }
        if ($PSBoundParameters.ContainsKey('RoleId')) {
            $roleLink = $query | Add-XrmQueryLink -ToEntityName "roleprivileges" -FromAttributeName "privilegeid" -ToAttributeName "privilegeid";
            $roleLink | Add-XrmQueryLinkCondition -Field "roleid" -Condition Equal -Values $RoleId | Out-Null;
        }
        $query = $query | Add-XrmQueryOrder -Field "name" -OrderType Ascending;
        $privileges = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity -AsArray;
        if ($privileges.Count -eq 0) {
            return;
        }

        # Tables of each privilege: one query, filtered on the privileges when they are few
        $entityQuery = New-XrmQueryExpression -LogicalName "privilegeobjecttypecodes" -Columns "privilegeid", "objecttypecode";
        if ($privileges.Count -le 500) {
            $entityQuery = $entityQuery | Add-XrmQueryCondition -Field "privilegeid" -Condition In -Values @($privileges | ForEach-Object { $_.Id });
        }
        $entitiesByPrivilege = @{};
        foreach ($row in ($XrmClient | Get-XrmMultipleRecords -Query $entityQuery -AsEntity -AsArray)) {
            $objectTypeCode = [string]$row["objecttypecode"];
            if ([string]::IsNullOrEmpty($objectTypeCode) -or $objectTypeCode -eq "none") {
                continue;
            }
            $privilegeId = $row["privilegeid"].Id;
            if (-not $entitiesByPrivilege.ContainsKey($privilegeId)) {
                $entitiesByPrivilege[$privilegeId] = [System.Collections.Generic.List[string]]::new();
            }
            $entitiesByPrivilege[$privilegeId].Add($objectTypeCode);
        }

        foreach ($privilege in $privileges) {
            $privilegeName = [string]$privilege["name"];
            $accessRightValue = [int]$privilege["accessright"];
            $accessRightName = "None";
            foreach ($right in $accessRights.Keys) {
                if ($accessRights[$right] -eq $accessRightValue) {
                    $accessRightName = $right;
                }
            }

            $entityNames = @();
            if ($entitiesByPrivilege.ContainsKey($privilege.Id)) {
                $entityNames = @($entitiesByPrivilege[$privilege.Id] | Sort-Object -Unique);
            }
            $entityName = $null;
            if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
                $entityName = $EntityLogicalName;
            }
            elseif ($entityNames.Count -eq 1) {
                $entityName = $entityNames[0];
            }
            elseif ($entityNames.Count -gt 1 -and $privilegeName.StartsWith("prv$accessRightName", [StringComparison]::OrdinalIgnoreCase)) {
                $nameSuffix = $privilegeName.Substring("prv$accessRightName".Length);
                $entityName = $entityNames | Where-Object { $_ -eq $nameSuffix } | Select-Object -First 1;
            }

            $supportedDepths = [System.Collections.Generic.List[Microsoft.Crm.Sdk.Messages.PrivilegeDepth]]::new();
            if ($privilege["canbebasic"]) { $supportedDepths.Add([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Basic); }
            if ($privilege["canbelocal"]) { $supportedDepths.Add([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Local); }
            if ($privilege["canbedeep"]) { $supportedDepths.Add([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Deep); }
            if ($privilege["canbeglobal"]) { $supportedDepths.Add([Microsoft.Crm.Sdk.Messages.PrivilegeDepth]::Global); }

            [PSCustomObject]@{
                Id                 = $privilege.Id;
                Name               = $privilegeName;
                AccessRight        = $accessRightName;
                AccessRightValue   = $accessRightValue;
                EntityLogicalName  = $entityName;
                EntityLogicalNames = $entityNames;
                CanBeBasic         = [bool]$privilege["canbebasic"];
                CanBeLocal         = [bool]$privilege["canbelocal"];
                CanBeDeep          = [bool]$privilege["canbedeep"];
                CanBeGlobal        = [bool]$privilege["canbeglobal"];
                SupportedDepths    = $supportedDepths.ToArray();
            };
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmPrivileges -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmPrivileges -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

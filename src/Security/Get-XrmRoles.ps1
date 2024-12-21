<#
    .SYNOPSIS
    Retrieve security roles.

    .DESCRIPTION
    Get security roles according to different criterias.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER BusinessUnitId
    Business Unit unique identifier where roles are associated.

    .PARAMETER OnlyRoots
    Specify if parent roles are retrieved or not. (Default : false = All roles)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER ExportPrivileges
    Specify if privileges are retrieved or not. (Default : false = No privileges)
#>
function Get-XrmRoles {
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [Guid]
        $BusinessUnitId,

        [Parameter(Mandatory = $false)]
        [switch]
        $OnlyRoots = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("roleid", "name", "parentrootroleid", "businessunitid"),

        [Parameter(Mandatory = $false)]
        [switch]
        $ExportPrivileges = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $queryRoles = New-XrmQueryExpression -LogicalName "role" -Columns $Columns;
        if ($PSBoundParameters.ContainsKey('BusinessUnitId')) {           
            $queryRoles = $queryRoles | Add-XrmQueryCondition -Field "businessunitid" -Condition Equal -Values $BusinessUnitId;
        }
        if ($OnlyRoots) {           
            $parentBusinessUnit = Get-XrmRootBusinessUnit;
            $queryRoles = $queryRoles | Add-XrmQueryCondition -Field "businessunitid" -Condition Equal -Values  $parentBusinessUnit.Id;
        }
        $roles = $XrmClient | Get-XrmMultipleRecords -Query $queryRoles;

        if ($ExportPrivileges) { 
            $roles | ForEach-Object {
                $privileges = Get-XrmRolePrivileges -XrmClient $XrmClient -RoleId $_.Id;
                $_ | Add-Member -MemberType NoteProperty -Name "Privileges" -Value $privileges;
            };
        }

        $roles;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmRoles -Alias *;
<#
    .SYNOPSIS
    Retrieve security role privileges.

    .DESCRIPTION
    Get role privileges from given role.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER RoleId
    Role unique identifier.
#>
function Get-XrmRolePrivileges {
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Guid]
        $RoleId        
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        if(-not $Global:PrivilegesCache){
            $queryPrivileges = New-XrmQueryExpression -LogicalName "privilege" -Columns "name";
            $allPrivileges = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryPrivileges;
                
            $Global:PrivilegesCache = @{};
            foreach($privilege in $allPrivileges){
                $Global:PrivilegesCache.Add($privilege.Id, $privilege.name);
            }
        }

        $request = New-XrmRequest -Name "RetrieveRolePrivilegesRole";
        $request = $request | Add-XrmRequestParameter -Name "RoleId" -Value $RoleId;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;

        $privileges = $response.Results["RolePrivileges"];
        foreach($privilege in $privileges) {
            $privilege.PrivilegeName = $Global:PrivilegesCache[$privilege.PrivilegeId];   
        }
        $privileges;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmRolePrivileges -Alias *;
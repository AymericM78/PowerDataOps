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
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
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
        $request = New-XrmRequest -Name "RetrieveRolePrivilegesRole";
        $request = $request | Add-XrmRequestParameter -Name "RoleId" -Value $RoleId;
        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;

        $privileges = $response.Results["RolePrivileges"];

        # Fix issue with empty privilege names
        $queryRolePrivileges = New-XrmQueryExpression -LogicalName "roleprivileges" -Columns * -top 1000;
        $queryRolePrivileges = $queryRolePrivileges | Add-XrmQueryCondition -Field "roleid" -Condition Equal -Values $RoleId;
        $link = Add-XrmQueryLink -Query $queryRolePrivileges -FromAttributeName "privilegeid" -ToEntityName "privilege" -ToAttributeName "privilegeid" -Alias "priv" -JoinOperator Inner;
        $link.Columns.AddColumn("name");
        $rolePrivileges = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryRolePrivileges;
        # Use dictionnary for better performances
        $privilegesCache = @{};
        foreach($privilege in $rolePrivileges){
            $privilegesCache.Add($privilege.privilegeid, $privilege.'priv.name');
        }
        # Fill missing privilege names
        foreach($privilege in $privileges) {
            $privilege.PrivilegeName = $privilegesCache[$privilege.PrivilegeId];   
        }
        $privileges;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmRolePrivileges -Alias *;
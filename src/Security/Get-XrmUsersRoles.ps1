<#
    .SYNOPSIS
    Retrieve assigned security roles for all users.

    .DESCRIPTION
    Get all users with associated roles. This could help to determine unused roles or bad configurations.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER UserQueryConditions
    Query condition arrays used to filter user query.
#>
function Get-XrmUsersRoles {
    [CmdletBinding()]
    param
    (       
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("fullname", "internalemailaddress"),

        [Parameter(Mandatory = $false)]
        $UserQueryConditions = @()
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        $queryUsers = New-XrmQueryExpression -LogicalName "systemuser" -Columns $Columns;
        foreach ($condition in $UserQueryConditions) {
            $queryUsers = $queryUsers.Criteria.AddCondition($condition);
        }
        $users = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryUsers;

        $Global:UsersRoles = @();
        ForEach-ObjectWithProgress -Collection $users -OperationName "Retrieve user roles" -ScriptBlock {
            param($user)

            $userRoles = Get-XrmUserRoles -XrmClient $XrmClient -UserId $user.Id;
            $userRoles | ForEach-Object {
                $Global:UsersRoles += [pscustomobject]@{
                    UserName   = $user.fullname;
                    RoleName   = $_.name;
                    UserObject = $user
                    RoleObject = $_
                }
            }            
        }
        $Global:UsersRoles;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUsersRoles -Alias *;
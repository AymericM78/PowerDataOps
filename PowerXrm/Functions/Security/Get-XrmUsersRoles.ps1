<#
    .SYNOPSIS
    Retrieve assigned security roles for all users
#>
function Get-XrmUsersRoles {
    [CmdletBinding()]    
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    (       
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
        foreach($condition in $UserQueryConditions)
        {
            $queryUsers = $queryUsers.Criteria.AddCondition($condition);
        }
        $users = Get-XrmMultipleRecords -Query $queryUsers;

        $Global:UsersRoles = @();
        ForEach-ObjectWithProgress -Collection $users -OperationName "Retrieve user roles" -ScriptBlock {
            param($user)

            $userRoles = Get-XrmUserRoles -UserId $user.Id;
            $userRoles | ForEach-Object {
                $Global:UsersRoles += [pscustomobject]@{
                    UserName = $user.fullname;
                    RoleName = $_.name;
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
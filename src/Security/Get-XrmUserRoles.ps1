<#
    .SYNOPSIS
    Retrieve user assigned security roles
#>
function Get-XrmUserRoles {
    [CmdletBinding()]    
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $UserId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("*")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
       
        $queryUserRoles = New-XrmQueryExpression -LogicalName "systemuserroles" -Columns "systemuserid", "roleid";
        $queryUserRoles = $queryUserRoles | Add-XrmQueryCondition -Field "systemuserid" -Condition Equal -Values $UserId;
        $queryUserRoles.TopCount = 100;
        $userRoles = $XrmClient | Get-XrmMultipleRecords -Query $queryUserRoles;

        $roles = @();
        $userRoles | ForEach-Object {
            $roles += Get-XrmRecord -Logicalname "role" -Id $_.roleid -Columns $Columns;
        }
        $roles;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUserRoles -Alias *;
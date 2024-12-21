<#
    .SYNOPSIS
    Retrieve user assigned security roles.

    .DESCRIPTION
    Get security roles associated to given user.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UserId
    System user unique identifier.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

#>
function Get-XrmUserRoles {
    [CmdletBinding()]
    param
    (       
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

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
        $userRoles = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryUserRoles;

        $roles = @();
        $userRoles | ForEach-Object {
            $roles += Get-XrmRecord -XrmClient $XrmClient -Logicalname "role" -Id $_.roleid -Columns $Columns;
        }
        $roles;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUserRoles -Alias *;
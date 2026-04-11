<#
    .SYNOPSIS
    Retrieve users from a team.

    .DESCRIPTION
    Get all system users that are members of a specified team.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER TeamReference
    Team entity reference.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : fullname, internalemailaddress)

    .EXAMPLE
    $xrmClient = New-XrmClient -ConnectionString $connectionString;
    $teamRef = New-XrmEntityReference -LogicalName "team" -Id $teamId;
    $users = Get-XrmUsersFromTeam -XrmClient $xrmClient -TeamReference $teamRef;
#>
function Get-XrmUsersFromTeam {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $TeamReference,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("fullname", "internalemailaddress")
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }    
    process {
        $queryUsers = New-XrmQueryExpression -LogicalName "systemuser" -Columns $Columns;
        $link = $queryUsers | Add-XrmQueryLink -ToEntityName "teammembership" -FromAttributeName "systemuserid" -ToAttributeName "systemuserid";
        $link | Add-XrmQueryLinkCondition -Field "teamid" -Condition Equal -Values @($TeamReference.Id) | Out-Null;
        $users = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryUsers;
        $users;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmUsersFromTeam -Alias *;

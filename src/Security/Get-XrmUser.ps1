<#
    .SYNOPSIS
    Retrieve user.

    .DESCRIPTION
    Get system user according to given ID, or primary email, with expected columns. Without UserId nor Email, the current user is returned.
    With Email, when several users share the address, the only enabled one is returned; an error is raised when that still leaves several users. Returns $null when no user has this address.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UserId
    System user unique identifier.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER Email
    Primary email of the user (internalemailaddress, case-insensitive). Cannot be combined with UserId.

    .OUTPUTS
    PSCustomObject. System user row (XrmObject).

    .EXAMPLE
    $me = Get-XrmUser -XrmClient $xrmClient -Columns "fullname";

    .EXAMPLE
    $user = Get-XrmUser -XrmClient $xrmClient -Email "jane.doe@contoso.com" -Columns "fullname", "businessunitid";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmUser.md
#>
function Get-XrmUser {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    ( 
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,
        
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $UserId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("*"),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Email
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSBoundParameters.ContainsKey('Email')) {
            if ($PSBoundParameters.ContainsKey('UserId')) {
                throw "Use either UserId or Email, not both.";
            }
            $queryColumns = @($Columns);
            if ($queryColumns -notcontains "*" -and $queryColumns -notcontains "isdisabled") {
                $queryColumns += "isdisabled";
            }
            $queryUsers = New-XrmQueryExpression -LogicalName "systemuser" -Columns $queryColumns;
            $queryUsers = $queryUsers | Add-XrmQueryCondition -Field "internalemailaddress" -Condition Equal -Values $Email;
            $users = $XrmClient | Get-XrmMultipleRecords -Query $queryUsers -AsArray;
            if ($users.Count -gt 1) {
                $users = @($users | Where-Object { -not ($_ | Get-XrmAttributeValue -Name "isdisabled") });
            }
            if ($users.Count -gt 1) {
                throw "Several enabled users have the email '$Email': $(($users | ForEach-Object { $_.Id }) -join ', ').";
            }
            if ($users.Count -eq 1) {
                $users[0];
            }
            return;
        }

        if (-not $PSBoundParameters.ContainsKey('UserId')) {
            $UserId = Get-XrmWhoAmI -XrmClient $XrmClient;
        }

        $user = $XrmClient | Get-XrmRecord -LogicalName "systemuser" -Id $UserId -Columns $Columns;
        $user;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUser -Alias *;
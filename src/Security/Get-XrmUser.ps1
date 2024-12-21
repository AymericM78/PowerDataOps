<#
    .SYNOPSIS
    Retrieve user.

    .DESCRIPTION
    Get system user according to given ID with expected columns.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER UserId
    System user unique identifier.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)
#>
function Get-XrmUser {
    [CmdletBinding()]
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
        $Columns = @("*")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        if (-not $PSBoundParameters.ContainsKey('UserId')) {
            # TODO : CrmServiceClient to ServiceClient migration.
            # $UserId = $XrmClient.GetMyCrmUserId();
        }

        $user = Get-XrmRecord -Logicalname "systemuser" -Id $UserId -Columns $Columns;
        $user;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUser -Alias *;
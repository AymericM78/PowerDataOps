<#
    .SYNOPSIS
    Retrieve user business unit.

    .DESCRIPTION
    Get user parent business unit.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UserId
    System user unique identifier.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)
#>
function Get-XrmUserBusinessUnit {
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
        $user = Get-XrmRecord -XrmClient $XrmClient -Logicalname "systemuser" -Id $UserId -Columns "businessunitid";
        $businessUnit = Get-XrmRecord -XrmClient $XrmClient -Logicalname "businessunit" -Id $user.businessunitid_Value.Id -Columns $Columns;
        $businessUnit;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUserBusinessUnit -Alias *;
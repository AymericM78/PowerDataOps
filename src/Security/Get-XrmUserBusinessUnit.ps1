<#
    .SYNOPSIS
    Retrieve user business unit
#>
function Get-XrmUserBusinessUnit {
    [CmdletBinding()]
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
        $user = Get-XrmRecord -Logicalname "systemuser" -Id $UserId -Columns "businessunitid";
        $businessUnit = Get-XrmRecord -Logicalname "businessunit" -Id $user.businessunitid_Value.Id -Columns $Columns;
        $businessUnit;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmUserBusinessUnit -Alias *;
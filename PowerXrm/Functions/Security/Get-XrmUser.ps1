<#
    .SYNOPSIS
    Retrieve user
#>
function Get-XrmUser {
    [CmdletBinding()]    
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    ( 
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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
            $UserId = $XrmClient.GetMyCrmUserId();
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
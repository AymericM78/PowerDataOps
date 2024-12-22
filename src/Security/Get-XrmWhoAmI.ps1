<#
    .SYNOPSIS
    Retrieve current user id.

    .DESCRIPTION
    Get system user unique identifier.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
#>
function Get-XrmWhoAmI {
    [CmdletBinding()]
    param
    ( 
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient        
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
    
        $request = new-xrmrequest -Name "WhoAmI";
        $response = Invoke-xrmRequest -XrmClient $XrmClient -Request $request;

        $userId = $response.Results["UserId"].Guid;
        $userId;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmWhoAmI -Alias *;
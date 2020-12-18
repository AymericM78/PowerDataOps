<#
    .SYNOPSIS
    Initialize Request object instance.
#>
function New-XrmRequest {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.OrganizationRequest")]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {

        $request = New-Object "Microsoft.Xrm.Sdk.OrganizationRequest" -ArgumentList $Name;
        return $request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function New-XrmRequest -Alias *;
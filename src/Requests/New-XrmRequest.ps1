<#
    .SYNOPSIS
    Initialize Request object instance.

    .DESCRIPTION
    Get a new Organization Request object instance.

    .PARAMETER Name
    Request name. (Microsoft Dataverse Web Api Function)
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
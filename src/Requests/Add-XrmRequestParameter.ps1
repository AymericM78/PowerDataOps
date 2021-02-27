<#
    .SYNOPSIS
    Add parameter to request.
#>
function Add-XrmRequestParameter {
    [CmdletBinding()]
    [OutputType("Microsoft.Xrm.Sdk.OrganizationRequest")]
    param
    ( 
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.OrganizationRequest]
        $Request,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [object]
        $Value
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
        if ($Request.Parameters.Contains($Name)) {
            throw "Request parameter '$Name' already added!"
        }

        $Request.Parameters.Add($Name, $Value);
        return $Request;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Add-XrmRequestParameter -Alias *;
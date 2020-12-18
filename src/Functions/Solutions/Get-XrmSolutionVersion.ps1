<#
    .SYNOPSIS
    Get solution version.
#>
function Get-XrmSolutionVersion {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $solution = $XrmClient | Get-XrmRecord -LogicalName "solution" -AttributeName "uniquename" -Value $SolutionUniqueName -Columns "version";
        if(-not $solution)
        {
            Write-HostAndLog -Message "Solution $SolutionUniqueName not found" -Level WARN;
            return $null;
        }
        $version = $solution.version;
        $version;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmSolutionVersion -Alias *;
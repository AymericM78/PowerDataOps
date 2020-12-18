<#
    .SYNOPSIS
    Run build action to upgrade solutions versions
#>
function Set-XrmSolutionsVersionBuild {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false)]
        [String]
        $ConnectionString = $env:CONNECTIONSTRING,

        [Parameter(Mandatory = $false)]
        [String]
        $BuildId = $env:BUILD_BUILDID,

        [Parameter(Mandatory = $false)]
        [String]
        $Version = $env:VERSION,

        [Parameter(Mandatory = $false)]
        [String]
        $Solutions = $env:SOLUTIONS
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
               
        $XrmClient = New-XrmClient -ConnectionString $ConnectionString;
        
        Write-HostAndLog -Message " - Param : Build ID = $BuildId" -Level INFO;
        Write-HostAndLog -Message " - Param : Solutions = $Solutions" -Level INFO;
        Write-HostAndLog -Message " - Param : Expected version = $Version" -Level INFO;

        $Version = $Version.Replace("X", $buildId);
        $Version = Get-Date -Format $Version;
        Write-HostAndLog -Message "Calculated version => $Version" -Level SUCCESS;

        $solutionList = $Solutions.Split(",");
        $solutionList | ForEach-Object {
            
            $XrmClient | Set-XrmSolutionVersion -SolutionUniqueName $_ -Version $Version;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmSolutionsVersionBuild -Alias *;
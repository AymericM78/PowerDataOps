<#
    .SYNOPSIS
    Set solution version.
#>
function Set-XrmSolutionVersion {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Version
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        Write-HostAndLog -Message "Set version $Version to solution $($SolutionUniqueName)..." -Level INFO;
        $solution = $XrmClient | Get-XrmRecord -LogicalName "solution" -AttributeName "uniquename" -Value $SolutionUniqueName -Columns "version";
        if (-not $solution) {
            Write-HostAndLog -Message "Solution $SolutionUniqueName not found" -Level WARN;
            return $null;
        }
        $solutionToUpdate = New-XrmEntity -LogicalName "solution" -Id $solution.Id;
        $solutionToUpdate = $solutionToUpdate | Set-XrmAttributeValue -Name version -Value $Version;
        $solutionToUpdate | Update-XrmRecord -XrmClient $XrmClient;
        
        Write-HostAndLog -Message "Solution $SolutionUniqueName has been successfully updated to version : $Version!" -Level SUCCESS;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Set-XrmSolutionVersion -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmSolutionVersion -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
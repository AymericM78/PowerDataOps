<#
    .SYNOPSIS
    Run build action to import solutions
#>
function Import-XrmSolutionsBuild {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [String]
        $ConnectionString = $env:CONNECTIONSTRING,

        [Parameter(Mandatory = $false)]
        [String]
        $ArtifactsPath = "$($Env:SYSTEM_DEFAULTWORKINGDIRECTORY)\Solutions\drop\",

        [Parameter(Mandatory = $false)]
        [String]
        $SolutionsImportOrder = $($env:SOLUTIONS_IMPORTORDER),

        [Parameter(Mandatory = $false)]
        [bool]
        $ClearPluginStepsAndTypes = $true,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PluginAssemblyName = "Plugins"
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
               
        $XrmClient = New-XrmClient -ConnectionString $ConnectionString;

        Write-HostAndLog -Message " - Param : ArtifactsPath = $ArtifactsPath" -Level INFO;
        Write-HostAndLog -Message " - Param : SolutionsImportOrder = $SolutionsImportOrder" -Level INFO;

        $solutionsToImport = $SolutionsImportOrder.Split(",");
        $solutionFilePaths = Get-ChildItem -Path "$ArtifactsPath\*.zip" -recurse;

        $orderedSolutions = @();
        foreach($solutionName in $solutionsToImport)
        {	
            $solutionFilePath = $solutionFilePaths | Where-Object { $_.Name.Contains($solutionName); };
            if(-not $solutionFilePath)
            {
                throw "Solution '$solutionName' not found in $($ArtifactsPath)";
            }
            $orderedSolutions += "$solutionName;$solutionFilePath";
        }

        Write-HostAndLog -Message "Solutions will be deployed in the following order:" -Level INFO;
        foreach($solution in $orderedSolutions)
        {
            $solutionName = $solution.ToString().Split(";")[0];
            Write-HostAndLog -Message " - $($solutionName)" -Level INFO;
        }

        Write-HostAndLog -Message "Clearing plugin steps and types:" -Level INFO;
        Remove-XrmPluginsFromAssembly -AssemblyName $PluginAssemblyName;
        Write-HostAndLog -Message "Plugin steps and types cleared!" -Level SUCCESS;

        foreach($solution in $orderedSolutions)
        {	    
            $solutionUniqueName = $solution.ToString().Split(";")[0];
            $solutionFilePath = $solution.ToString().Split(";")[1];
            
            Write-HostAndLog -Message "Importing $solutionUniqueName from $solutionFilePath" -Level INFO;
            $XrmClient | Import-XrmSolution -SolutionUniqueName $solutionUniqueName -SolutionFilePath $solutionFilePath;
            Write-HostAndLog -Message "Solution $($solutionUniqueName) successfully imported" -Level SUCCESS;

            if($env:SLACKURL)
            {
                Write-XrmMessageToSlack -Message "Solution $($solutionUniqueName) successfully imported!";
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Import-XrmSolutionsBuild -Alias *;
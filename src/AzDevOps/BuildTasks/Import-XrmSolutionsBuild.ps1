<#
    .SYNOPSIS
    Run build action to import solutions

    .DESCRIPTION
    This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
    This cmdlet import given solutions from artifacts.

    .PARAMETER ConnectionString
    Target instance connection string, use variable 'ConnectionString' from associated variable group.

    .PARAMETER ArtifactsPath
    Folder path where solutions will be imported. (Default: Agent default working directory)

    .PARAMETER SolutionsImportOrder
    Solution uniquenames that will be imported in given order, use variable 'Solutions.ImportOrder' from associated variable group.

    .PARAMETER ClearPluginStepsAndTypes
    Indicates if plugins need to be unregistered prior solution import. (Default: true)

    .PARAMETER PluginAssemblyName
    Specify plugin assembly name for plugin removal operation. (Default: Plugins)
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
        [String]
        $SolutionsImportIgnore = $($env:SOLUTIONS_IMPORTIGNORE),

        [Parameter(Mandatory = $false)]
        [String]
        $SolutionsImportUpgrade = $($env:SOLUTIONS_IMPORTUPGRADE),

        [Parameter(Mandatory = $false)]
        [bool]
        $ClearPluginStepsAndTypes = $true,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PluginAssemblyName = "Plugins",
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $Upgrade = $false
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

        $solutionsToIgnore = $SolutionsImportIgnore.Split(",");
        $solutionsToUpgrade = $SolutionsImportUpgrade.Split(",");

        $orderedSolutions = @();
        foreach ($solutionName in $solutionsToImport) {	

            # Solution file name detection
            # ----------------------------
            # > Case 1 : managed solution
            $solutionFilePath = $solutionFilePaths | Where-Object { $_.Name.EndsWith("$($solutionName)_managed.zip"); } | Select-Object -First 1;
            if(-not $solutionFilePath) {
                # > Case 2 : unmanaged solution
                $solutionFilePath = $solutionFilePaths | Where-Object { $_.Name.EndsWith("$($solutionName).zip"); } | Select-Object -First 1;
                if(-not $solutionFilePath) {
                    # > Case 3 : other ?
                    $solutionFilePath = $solutionFilePaths | Where-Object { $_.Name.Contains($solutionName); } | Select-Object -First 1;
                    if (-not $solutionFilePath) {
                        throw "Solution '$solutionName' not found in $($ArtifactsPath)";
                    }
                }
            }

            $orderedSolutions += "$solutionName;$solutionFilePath";
        }

        Write-HostAndLog -Message "Solutions will be deployed in the following order:" -Level INFO;
        foreach ($solution in $orderedSolutions) {
            $solutionName = $solution.ToString().Split(";")[0];
            $ignoreFlag = "";
            if($solutionsToIgnore.Contains($solutionName)) {
                $ignoreFlag = " [Ignored] "
            }
            $upgradeFlag = "";
            if($solutionsToUpgrade.Contains($solutionName)) {
                $upgradeFlag = " [Upgrade] "
            }
            Write-HostAndLog -Message " - $($solutionName) $ignoreFlag $upgradeFlag" -Level INFO;
        }

        foreach ($solution in $orderedSolutions) {	    
            $solutionUniqueName = $solution.ToString().Split(";")[0];
            $solutionFilePath = $solution.ToString().Split(";")[1];

            if($solutionsToIgnore.Contains($solutionUniqueName)) {
                Write-HostAndLog -Message "Solution $solutionUniqueName will not be imported (ignored)" -Level INFO;
                continue;
            }

            if ($orderedSolutions.Length -eq 1 -or $solutionUniqueName.ToLower().Contains("plugin")) {                    
                Write-HostAndLog -Message "Clearing plugin steps and types:" -Level INFO;
                Remove-XrmPluginsFromAssembly -AssemblyName $PluginAssemblyName;
                Write-HostAndLog -Message "Plugin steps and types cleared!" -Level SUCCESS;
            }
            
            Write-HostAndLog -Message "Importing $solutionUniqueName from $solutionFilePath" -Level INFO;
            $upgradeRequired = $false;
            if(-not $Upgrade) {
                $upgradeRequired = $solutionsToUpgrade.Contains($solutionUniqueName);
            }
            $XrmClient | Import-XrmSolution -SolutionUniqueName $solutionUniqueName -SolutionFilePath $solutionFilePath -Upgrade $upgradeRequired;
            Write-HostAndLog -Message "Solution $($solutionUniqueName) successfully imported" -Level SUCCESS;

            if ($env:SLACKURL) {
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
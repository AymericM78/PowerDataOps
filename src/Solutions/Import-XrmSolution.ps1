<#
    .SYNOPSIS
    Import solution.

    .DESCRIPTION
    Performs solution import to target instance.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to import.

    .PARAMETER SolutionFilePath
    Full path to solution file (.zip).

    .PARAMETER PublishWorkflows
    Gets or sets whether any processes (workflows) included in the solution should be activated after they are imported. (Default : true)

    .PARAMETER OverwriteUnmanagedCustomizations
    Gets or sets whether any unmanaged customizations that have been applied over existing managed solution components should be overwritten. (Default : true)

    .PARAMETER ConvertToManaged
    Direct the system to convert any matching unmanaged customizations into your managed solution. (Default : false)

    .PARAMETER Upgrade
    Gets or sets whether to import the solution as a holding solution with immediate application of the upgrade. (Default : false)

    .PARAMETER SkipProductUpdateDependencies
    Gets or sets whether enforcement of dependencies related to product updates should be skipped. (Default : false)
    
    .PARAMETER StartUpgrade
    Start Upgrade operation immediatly after solution import. (Default : false)
#>
function Import-XrmSolution {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [String]
        $SolutionFilePath,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $PublishWorkflows = $true,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $OverwriteUnmanagedCustomizations = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ConvertToManaged = $false,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $Upgrade = $false,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $SkipProductUpdateDependencies = $true,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $StartUpgrade = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        # Retrieve solution content
        $solutionContent = [System.IO.File]::ReadAllBytes($SolutionFilePath);
        
        # Initialize import solution request
        $importJobId = New-Guid;

        $importSolutionRequest = New-XrmRequest -Name "ImportSolution";
        $importSolutionRequest | Add-XrmRequestParameter -Name "ImportJobId" -Value $importJobId | Out-Null;
        $importSolutionRequest | Add-XrmRequestParameter -Name "CustomizationFile" -Value $solutionContent | Out-Null;
        $importSolutionRequest | Add-XrmRequestParameter -Name "PublishWorkflows" -Value $PublishWorkflows | Out-Null;
        $importSolutionRequest | Add-XrmRequestParameter -Name "OverwriteUnmanagedCustomizations" -Value $OverwriteUnmanagedCustomizations | Out-Null;
        $importSolutionRequest | Add-XrmRequestParameter -Name "ConvertToManaged" -Value $ConvertToManaged | Out-Null;
        $importSolutionRequest | Add-XrmRequestParameter -Name "SkipProductUpdateDependencies" -Value $SkipProductUpdateDependencies | Out-Null;
        
        if($StartUpgrade){
            $Upgrade = $true;
        }
        if ($Upgrade) {
            $importSolutionRequest | Add-XrmRequestParameter -Name "HoldingSolution" -Value $true | Out-Null;
        }

        try {            
            $importSolutionResponse = $XrmClient | Invoke-XrmRequest -Request $importSolutionRequest -Async;
            $asyncOperationId = $importSolutionResponse.AsyncJobId;

            $importJob = $null;
            $lastProgressValue = $null;
            Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId -ScriptBlock {
                param($asyncOperation)

                try {
                    $importJob = $XrmClient | Get-XrmRecord -LogicalName "importjob" -Id $importJobId -Columns "completedon", "data", "progress";                    
                }
                catch {
                    # First import job retrieve could failed if the delay is too short
                    return;
                }
                if ($importJob.progress -ne $lastProgressValue) {                    
                    Write-HostAndLog " > $SolutionUniqueName import in progress... ($($importJob.progress) %)" -ForegroundColor Cyan;
                    Write-Progress -Activity $($MyInvocation.MyCommand.Name) -Status "Importing solution $SolutionUniqueName...($($importJob.progress) %)" -PercentComplete $importJob.progress_Value -Id 1052;
                    $progressValue = $importJob.progress_Value -as [int];
                    Write-Output "##vso[task.setprogress value=$progressValue;]Solution Import Progress"
                }
                $lastProgressValue = $importJob.progress;
            }

            $importJob = $XrmClient | Get-XrmRecord -LogicalName "importjob" -Id $importJobId -Columns "completedon", "data", "progress";
            $xmlData = [xml] $importJob.data;
            $resultNode = $xmlData.importexportxml.solutionManifests.solutionManifest.result;
            if ($resultNode.result -eq "failure") {        
                throw "$($resultNode.errorcode): $($resultNode.errortext)";
            }
        }
        catch {
            $errorMessage = $_.Exception.Message;
            Write-HostAndLog "$($MyInvocation.MyCommand.Name) => KO : [Error: $errorMessage]" -ForegroundColor Red -Level FAIL;
            Write-Progress -Activity $($MyInvocation.MyCommand.Name) -Id 1052 -Completed;
            throw $errorMessage;
        }  

        if ($StartUpgrade) {
            Start-XrmSolutionUpgrade -SolutionUniqueName $SolutionUniqueName;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Import-XrmSolution -Alias *;

Register-ArgumentCompleter -CommandName Import-XrmSolution -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}

<#
    .SYNOPSIS
    Import solution.
#>
function Import-XrmSolution {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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
        $OverwriteUnmanagedCustomizations = $true,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ConvertToManaged = $false,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $Upgrade = $false,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $SkipProductUpdateDependencies = $true
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
        if($Upgrade)
        {
            $importSolutionRequest | Add-XrmRequestParameter -Name "HoldingSolution" -Value $Upgrade | Out-Null;
        }

        try 
        {            
            $importSolutionResponse = $XrmClient | Invoke-XrmRequest -Request $importSolutionRequest -Async;
            $asyncOperationId =  $importSolutionResponse.AsyncJobId;

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
                    Write-Progress -Activity $($MyInvocation.MyCommand.Name) -Status "Importing solution $SolutionUniqueName...($($importJob.progress) %)" -PercentComplete $importJob.progress_Value;
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
            write-progress one one -completed;
            throw $errorMessage;
        }  

        if($Upgrade)
        {
            Start-XrmSolutionUpgrade -SolutionUniqueName $SolutionUniqueName;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Import-XrmSolution -Alias *;
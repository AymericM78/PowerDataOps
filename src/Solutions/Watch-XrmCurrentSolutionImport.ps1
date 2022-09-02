<#
    .SYNOPSIS
    Monitor current solution import.

    .DESCRIPTION
    Poll latest solution import status until its done and display progress.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
#>
function Watch-XrmCurrentSolutionImport {
    [CmdletBinding()]
    param
    (  
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        $queryImportJobs = New-XrmQueryExpression -LogicalName "importjob" -TopCount 1;
        $queryImportJobs = $queryImportJobs | Add-XrmQueryOrder -Field "startedon" -OrderType Descending;
        $importJobs = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryImportJobs;

        $importJob = $importJobs | Select-Object -First 1;
        if (-not $importJob) {
            Write-HostAndLog -Message "Import job not found" -Level WARN;
            return;
        }

        $importJobId = $importJob.Id;
        while ($true) {
            try {
                $importJob = $XrmClient | Get-XrmRecord -LogicalName "importjob" -Id $importJobId -Columns "solutionname", "completedon", "data", "progress";                    
            }
            catch {
                # First import job retrieve could failed if the delay is too short
                return;
            }
            if ($importJob.progress -ne $lastProgressValue) {
                Write-HostAndLog " > $($importJob.solutionname) import in progress... ($($importJob.progress) %)" -ForegroundColor Cyan;
                Write-Progress -Activity $($MyInvocation.MyCommand.Name) -Status "Importing solution $SolutionUniqueName...($($importJob.progress) %)" -PercentComplete $importJob.progress_Value -Id 1053;
            }
            if ($importJob.completedon) {                
                Write-HostAndLog " > $($importJob.solutionname) import completed!" -ForegroundColor Green;
                Write-Progress -Activity "N/A" -Id 1053 -Completed;
                break;
            }
            $lastProgressValue = $importJob.progress;            
        }        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Watch-XrmCurrentSolutionImport -Alias *;
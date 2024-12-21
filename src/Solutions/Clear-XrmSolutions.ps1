<#
    .SYNOPSIS
    Select solutions to uninstall.

    .DESCRIPTION
    Select solutions (managed or unmanaged) and delete them.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, version, ismanaged, installedon, createdby, publisherid, modifiedon, modifiedby)

    .PARAMETER TimeOutInMinutes
    Specify timeout duration in minute for each solution deletion. (Default : 45 min)
#>
function Clear-XrmSolutions {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("solutionid", "uniquename", "friendlyname", "version", "ismanaged", "installedon", "createdby", "publisherid", "modifiedon", "modifiedby"),
        
        [Parameter(Mandatory = $false)]
        [int]
        $TimeOutInMinutes = 45
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $solutionsToRemove = Select-XrmSolutions -XrmClient $XrmClient -Columns $Columns -OutputMode Multiple;
                
        $XrmClient | Set-XrmClientTimeout -DurationInMinutes $TimeOutInMinutes;

        ForEach-ObjectWithProgress -Collection $solutionsToRemove -OperationName "Uninstall solutions" -ScriptBlock {
            param($solution)

            Write-HostAndLog "  > Removing solution " -NoNewline -NoTimeStamp -ForegroundColor Gray;
            Write-HostAndLog $solution.friendlyname -NoNewline -NoTimeStamp -ForegroundColor Yellow;
            Write-HostAndLog " ..." -NoNewline -NoTimeStamp -ForegroundColor Gray;

            $stopWatch = [System.Diagnostics.Stopwatch]::StartNew();
            try {
                $solutionToDelete = New-XrmEntity -LogicalName "solution" -Id $solution.solutionid;
                $XrmClient | Remove-XrmRecord -Record $solutionToDelete;
                $stopWatch.Stop();
                
                Write-Host "[OK] (Duration = $($stopWatch.Elapsed.ToString("g")))" -ForegroundColor Green;
            }
            catch {
                $stopWatch.Stop();
                Write-Host "[KO : $($_.Exception.Message)] (Duration = $($stopWatch.Elapsed.ToString("g")))" -ForegroundColor Red;
            }
        }
        
        $XrmClient | Set-XrmClientTimeout -Revert;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Clear-XrmSolutions -Alias *;
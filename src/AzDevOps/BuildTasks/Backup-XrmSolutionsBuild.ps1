<#
    .SYNOPSIS
    Run build action to unpack solutions
#>
function Backup-XrmSolutionsBuild {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [String]
        $ConnectionString = $env:CONNECTIONSTRING,
        
        [Parameter(Mandatory = $false)]
        [String]
        $UnpackPath = $env:SYSTEM_DEFAULTWORKINGDIRECTORY,

        [Parameter(Mandatory = $false)]
        [String]
        $Solutions = $env:SOLUTIONS,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $Managed = $false,

        [Parameter(Mandatory = $false)]
        [String]
        $DefaultExportPath = $env:TEMP
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        $XrmClient = New-XrmClient -ConnectionString $ConnectionString;
        $solutionList = $Solutions.Split(",");
        $solutionList | ForEach-Object {
            
            Write-HostAndLog -Message "Exporting solution $($_)" -Level INFO;           
            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $_ -Managed $Managed -ExportPath $DefaultExportPath -ExportCalendarSettings $true -ExportCustomizationSettings $true -ExportEmailTrackingSettings $true  -ExportAutoNumberingSettings $true  -ExportIsvConfig $true  -ExportOutlookSynchronizationSettings $true  -ExportGeneralSettings $true  -ExportMarketingSettings $true  -ExportRelationshipRoles $true;                
            Write-HostAndLog -Message "Solution $($_) successfully exported to '$solutionFilePath' !" -Level SUCCESS;

            $solutionUnpackPath = "$UnpackPath\$solutionName";
            Invoke-XrmSolutionPackager -Action Extract -SolutionFilePath $solutionFilePath -FolderPath $solutionUnpackPath;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Backup-XrmSolutionsBuild -Alias *;
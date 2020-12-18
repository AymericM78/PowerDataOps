<#
    .SYNOPSIS
    Run build action to export solutions
#>
function Export-XrmSolutionsBuild {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [String]
        $ConnectionString = $env:CONNECTIONSTRING,

        [Parameter(Mandatory = $false)]
        [String]
        $ExportPath = $env:BUILD_ARTIFACTSTAGINGDIRECTORY,

        [Parameter(Mandatory = $false)]
        [String]
        $Solutions = $env:SOLUTIONS,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $Managed = $true,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportCalendarSettings = $false,
        
        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportCustomizationSettings = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportEmailTrackingSettings = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportAutoNumberingSettings = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportIsvConfig = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportOutlookSynchronizationSettings = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportGeneralSettings = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportMarketingSettings = $false,

        [Parameter(Mandatory = $false)]
        [Boolean]
        $ExportRelationshipRoles = $false       
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $XrmClient = New-XrmClient -ConnectionString $ConnectionString -MaxCrmConnectionTimeOutMinutes 15;

        Write-HostAndLog -Message " - Param : Export path = $ExportPath" -Level INFO;
        Write-HostAndLog -Message " - Param : Managed = $Managed" -Level INFO;
        Write-HostAndLog -Message " - Param : Solutions = $Solutions" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportCalendarSettings = $ExportCalendarSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportCustomizationSettings = $ExportCustomizationSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportEmailTrackingSettings = $ExportEmailTrackingSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportAutoNumberingSettings = $ExportAutoNumberingSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportIsvConfig = $ExportIsvConfig" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportOutlookSynchronizationSettings = $ExportOutlookSynchronizationSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportGeneralSettings = $ExportGeneralSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportMarketingSettings = $ExportMarketingSettings" -Level INFO;
        Write-HostAndLog -Message " - Param : ExportRelationshipRoles = $ExportRelationshipRoles" -Level INFO;

        $solutionList = $Solutions.Split(",");
        $solutionList | ForEach-Object {
            
            Write-HostAndLog -Message "Exporting solution $($_)" -Level INFO;           
            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $_ -Managed $Managed -ExportPath $ExportPath -ExportCalendarSettings $ExportCalendarSettings -ExportCustomizationSettings $ExportCustomizationSettings -ExportEmailTrackingSettings $ExportEmailTrackingSettings  -ExportAutoNumberingSettings $ExportAutoNumberingSettings  -ExportIsvConfig $ExportIsvConfig  -ExportOutlookSynchronizationSettings $ExportOutlookSynchronizationSettings  -ExportGeneralSettings $ExportGeneralSettings  -ExportMarketingSettings $ExportMarketingSettings  -ExportRelationshipRoles $ExportRelationshipRoles;                
            Write-HostAndLog -Message "Solution $($_) successfully exported to '$solutionFilePath' !" -Level SUCCESS;

            if($env:SLACKURL)
            {
                Write-XrmMessageToSlack -Message "Solution $($_) successfully exported to '$solutionFilePath' !";
            }
        }        
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Export-XrmSolutionsBuild -Alias *;
<#
    .SYNOPSIS
    Run build action to export solutions.

    .DESCRIPTION
    This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
    This cmdlet export given solutions in order to add them to build artifacts.

    .PARAMETER ConnectionString
    Target instance connection string, use variable 'ConnectionString' from associated variable group.

    .PARAMETER ExportPath
    Folder path where solutions will be exported. (Default: Agent Artifacts Staging directory)

    .PARAMETER Solutions
    Solution uniquenames that will be exported and then unpacked, use variable 'Solutions' from associated variable group.

    .PARAMETER Managed
    Specify if solution should be export as managed or unmanaged. (Default: true = managed)

    .PARAMETER ExportCalendarSettings
    Specify if exported solution should include Calendar settings (Default: false)

    .PARAMETER ExportCustomizationSettings
    Specify if exported solution should include Customization settings (Default: false)

    .PARAMETER ExportEmailTrackingSettings
    Specify if exported solution should include Email Tracking settings (Default: false)

    .PARAMETER ExportAutoNumberingSettings
    Specify if exported solution should include AutoNumbering settings (Default: false)

    .PARAMETER ExportIsvConfig
    Specify if exported solution should include Isv settings (Default: false)

    .PARAMETER ExportOutlookSynchronizationSettings
    Specify if exported solution should include Outlook Synchronization settings (Default: false)

    .PARAMETER ExportGeneralSettings
    Specify if exported solution should include General settings (Default: false)

    .PARAMETER ExportMarketingSettings
    Specify if exported solution should include Marketing settings (Default: false)

    .PARAMETER ExportRelationshipRoles
    Specify if exported solution should include RelationshipRoles (Default: false)
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
        $ExportRelationshipRoles = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $ForceSyncExport = $false
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        $XrmClient = New-XrmClient -ConnectionString $ConnectionString;

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

        # =========================================================================================================
        # Step issue path : filtering attributes on create steps
        # =========================================================================================================

        Write-HostAndLog -Message "Apply steps issue patch" -Level INFO;        
        $query = New-XrmQueryExpression -LogicalName "sdkmessageprocessingstep" -Columns "name";
        $query = $query | Add-XrmQueryCondition -Field "sdkmessageidname" -Condition Equal -Values "Create";
        $query = $query | Add-XrmQueryCondition -Field "filteringattributes" -Condition NotNull;
        $query = $query | Add-XrmQueryCondition -Field "ishidden" -Condition Equal -Values $false;
        $query = $query | Add-XrmQueryCondition -Field "iscustomizable" -Condition Equal -Values $true;

        $steps = Get-XrmMultipleRecords -Query $query;
        foreach($step in $steps){
            
            Write-HostAndLog -Message " > Step '$($step.name)' contains filtering attributes" -Level WARN;  

            $stepUpdate = New-XrmEntity -LogicalName $step.LogicalName -Id $step.id -Attributes @{
                "filteringattributes" = $null;
            };
            Update-XrmRecord -Record $stepUpdate;
        }
        Write-HostAndLog -Message "$($steps.Count) step(s) updated!" -Level WARN;  
        # =========================================================================================================

        $solutionList = $Solutions.Split(",");
        $solutionList | ForEach-Object {
            
            Write-HostAndLog -Message "Exporting solution $($_)" -Level INFO;           
            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $_ -Managed $Managed -ExportPath $ExportPath -ExportCalendarSettings $ExportCalendarSettings -ExportCustomizationSettings $ExportCustomizationSettings -ExportEmailTrackingSettings $ExportEmailTrackingSettings  -ExportAutoNumberingSettings $ExportAutoNumberingSettings  -ExportIsvConfig $ExportIsvConfig  -ExportOutlookSynchronizationSettings $ExportOutlookSynchronizationSettings  -ExportGeneralSettings $ExportGeneralSettings  -ExportMarketingSettings $ExportMarketingSettings  -ExportRelationshipRoles $ExportRelationshipRoles -ForceSyncExport:$ForceSyncExport;
            Write-HostAndLog -Message "Solution $($_) successfully exported to '$solutionFilePath' !" -Level SUCCESS;

            if ($env:SLACKURL) {
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
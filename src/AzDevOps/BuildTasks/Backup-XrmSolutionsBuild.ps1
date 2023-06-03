<#
    .SYNOPSIS
    Run build action to unpack solutions

    .DESCRIPTION
    This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
    This cmdlet export given solutions and then start SolutionPackager extract action to working directory.

    .PARAMETER ConnectionString
    Target instance connection string, use variable 'ConnectionString' from associated variable group.

    .PARAMETER UnpackPath
    Folder path where solutions will be extracted. (Default: Agent working directory)

    .PARAMETER Solutions
    Solution uniquenames that will be exported and then unpacked, use variable 'Solutions' from associated variable group.

    .PARAMETER Managed
    Specify if solution should be export as managed or unmanaged. (Default: false = unmanaged)

    .PARAMETER DefaultExportPath
    Folder path where solutions will be exported before unpacked. (Default: Agent temp directory)
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
        $DefaultExportPath = $env:TEMP,

        [Parameter(Mandatory = $false)]
        [int]
        $TimeoutInMinutes = 10
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
            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $_ -Managed $Managed -ExportPath $DefaultExportPath -ExportCalendarSettings $true -ExportCustomizationSettings $true -ExportEmailTrackingSettings $true  -ExportAutoNumberingSettings $true  -ExportIsvConfig $true  -ExportOutlookSynchronizationSettings $true  -ExportGeneralSettings $true  -ExportMarketingSettings $true  -ExportRelationshipRoles $true -TimeoutInMinutes $TimeoutInMinutes;                
            Write-HostAndLog -Message "Solution $($_) successfully exported to '$solutionFilePath' !" -Level SUCCESS;

            Write-HostAndLog -Message "Unpacking solution $($_)" -Level INFO;   
            $solutionUnpackPath = "$UnpackPath\$_";
            Invoke-XrmSolutionPackager -Action Extract -SolutionFilePath $solutionFilePath -FolderPath $solutionUnpackPath;
            Write-HostAndLog -Message "Solution $($_) successfully unpacked to '$solutionUnpackPath' !" -Level SUCCESS;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Backup-XrmSolutionsBuild -Alias *;
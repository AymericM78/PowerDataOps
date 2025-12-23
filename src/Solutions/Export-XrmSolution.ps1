<#
    .SYNOPSIS
    Export solution.

    .DESCRIPTION
    Export given solution with given settings.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name to export.

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

    .PARAMETER AddVersionToFileName
    Specify if solution version number should be added to file name. (Default: false)

    .PARAMETER ForceSyncExport
    Specify if solution should be exported synchronously. (Default: false)
#>
function Export-XrmSolution {
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

        [Parameter(Mandatory = $false)]
        [Boolean]
        $Managed = $false,

        [Parameter(Mandatory = $false)]
        [ValidateScript( { Test-Path $_ })]
        [String]
        $ExportPath = $env:TEMP,

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
        [Boolean]
        $AddVersionToFileName = $false,

        [Parameter(Mandatory = $false)]
        [switch]
        $ForceSyncExport = $false,

        [Parameter(Mandatory = $false)]
        [int]
        $TimeoutInMinutes = 10
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        # Build solution file name
        $solutionFileName = $SolutionUniqueName;
        if ($AddVersionToFileName) {            
            $solution = $XrmClient | Get-XrmRecord -LogicalName "solution" -AttributeName "uniquename" -Value $SolutionUniqueName -Columns "version";
            $version = $solution.version;
            $version = $version.Replace(".", "_");
            $solutionFileName = "$($solutionFileName)_$($version)";
        }
        
        if ($managed) {
            $solutionFileName = "$($solutionFileName)_managed";
        }

        $solutionFileName = "$($solutionFileName).zip";

        # Build output path
        $solutionFilePath = [System.IO.Path]::Combine($ExportPath, $solutionFileName);
        
        # Build request
        if ($ForceSyncExport) {
            $exportSolutionRequest = New-XrmRequest -Name "ExportSolution";
        }
        else {
            $exportSolutionRequest = New-XrmRequest -Name "ExportSolutionAsync";
        }
        $exportSolutionRequest | Add-XrmRequestParameter -Name "SolutionName" -Value $SolutionUniqueName | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "Managed" -Value $Managed | Out-Null;    
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportCalendarSettings" -Value $ExportCalendarSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportCustomizationSettings" -Value $ExportCustomizationSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportEmailTrackingSettings" -Value $ExportEmailTrackingSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportAutoNumberingSettings" -Value $ExportAutoNumberingSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportIsvConfig" -Value $ExportIsvConfig | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportOutlookSynchronizationSettings" -Value $ExportOutlookSynchronizationSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportGeneralSettings" -Value $ExportGeneralSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportMarketingSettings" -Value $ExportMarketingSettings | Out-Null;
        $exportSolutionRequest | Add-XrmRequestParameter -Name "ExportRelationshipRoles" -Value $ExportRelationshipRoles | Out-Null;

        # Run request
        try {
            $exportSolutionResponse = $XrmClient | Invoke-XrmRequest -Request $exportSolutionRequest;
        }
        catch {
            throw $_.Exception.Message;
        }


        if ($ForceSyncExport) {
            $solutionBinaries = $exportSolutionResponse.Results["ExportSolutionFile"];
        }
        else {
            
            $asyncOperationId = $exportSolutionResponse.Results["AsyncOperationId"];
            $exportJobId = $exportSolutionResponse.Results["ExportJobId"];

            # Monitor request execution
            $XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId -TimeoutInMinutes $TimeoutInMinutes;

            # Retrieve solution file binary
            $downloadSolutionExportDataRequest = New-XrmRequest -Name "DownloadSolutionExportData";
            $downloadSolutionExportDataRequest | Add-XrmRequestParameter -Name "ExportJobId" -Value $exportJobId | Out-Null;
            try {
                $downloadSolutionExportDataResponse = $XrmClient | Invoke-XrmRequest -Request $downloadSolutionExportDataRequest;
            }
            catch {
                throw $_.Exception.Message;
            }
            $solutionBinaries = $downloadSolutionExportDataResponse.Results["ExportSolutionFile"];
        }

        # Save solution file
        [System.IO.File]::WriteAllBytes($solutionFilePath, $solutionBinaries);

        # Output solution file path
        $solutionFilePath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Export-XrmSolution -Alias *;

Register-ArgumentCompleter -CommandName Export-XrmSolution -ParameterName "SolutionUniqueName" -ScriptBlock {

    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)

    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}
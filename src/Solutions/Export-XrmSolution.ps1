<#
    .SYNOPSIS
    Export solution.
#>
function Export-XrmSolution {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
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
        $AddVersionToFileName = $false
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

        # Define async export solution feature
        Set-XrmOrganizationFeature -Name "FCB.AllowExportSolutionAsync" -Value "true";
        
        # Build request        
        $exportSolutionRequest = New-XrmRequest -Name "ExportSolutionAsync";
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
        $asyncOperationId = $exportSolutionResponse.Results["AsyncOperationId"];
        $exportJobId = $exportSolutionResponse.Results["ExportJobId"];

        # Monitor request execution
        $XrmClient | Watch-XrmAsynchOperation -AsyncOperationId $asyncOperationId;

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
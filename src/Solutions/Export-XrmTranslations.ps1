<#
    .SYNOPSIS
    Export the translations of a solution.

    .DESCRIPTION
    Export the localizable labels of an unmanaged solution (ExportTranslation): a zip file holding CrmTranslations.xml, one column per provisioned language.
    The request is synchronous: a large solution can take several minutes.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name.

    .PARAMETER ExportPath
    Folder where the file is written. (Default: TEMP folder)

    .PARAMETER Unpack
    Extract the file into a folder named after it and return the folder path instead of the file path.

    .OUTPUTS
    System.String. Path of the translation file (CrmTranslations_<SolutionUniqueName>.zip), or of the extracted folder with Unpack.

    .EXAMPLE
    $folder = Export-XrmTranslations -XrmClient $xrmClient -SolutionUniqueName "ContosoCore" -ExportPath "C:\Temp" -Unpack;
    [xml]$translations = Get-Content -Path (Join-Path $folder "CrmTranslations.xml") -Raw;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmTranslations.md
#>
function Export-XrmTranslations {
    [CmdletBinding()]
    [OutputType([String])]
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
        [ValidateScript( { Test-Path $_ })]
        [String]
        $ExportPath = [System.IO.Path]::GetTempPath(),

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpack
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "ExportTranslation";
        $request = $request | Add-XrmRequestParameter -Name "SolutionName" -Value $SolutionUniqueName;
        try {
            $response = $XrmClient | Invoke-XrmRequest -Request $request -ErrorAction Stop;
        }
        catch {
            throw "Cannot export the translations of solution '$SolutionUniqueName': $($_.Exception.Message)";
        }

        $filePath = [System.IO.Path]::Combine($ExportPath, "CrmTranslations_$SolutionUniqueName.zip");
        [System.IO.File]::WriteAllBytes($filePath, $response.Results["ExportTranslationFile"]);
        if ($Unpack) {
            $folderPath = [System.IO.Path]::ChangeExtension($filePath, $null);
            Expand-Archive -Path $filePath -DestinationPath $folderPath -Force;
            return $folderPath;
        }
        $filePath;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Export-XrmTranslations -Alias *;

Register-ArgumentCompleter -CommandName Export-XrmTranslations -ParameterName "SolutionUniqueName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $solutionUniqueNames = @();
    $solutions = Get-XrmSolutions -Columns "uniquename";
    $solutions | ForEach-Object { $solutionUniqueNames += $_.uniquename };
    return $solutionUniqueNames | Where-Object { $_ -like "$wordToComplete*" } | Sort-Object;
}

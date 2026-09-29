<#
    .SYNOPSIS
    Retrieve the ribbon customizations (RibbonDiffXml) of several tables with one solution export.

    .DESCRIPTION
    Export an unmanaged solution holding the tables and read the RibbonDiffXml of each one in customizations.xml.
    Without SolutionUniqueName, a temporary solution holding the tables is created with the publisher given by PublisherUniqueName (or the organization default publisher), exported, then removed, even on failure.
    Returns one object per table: EntityLogicalName, RibbonDiffXml (XmlElement, $null when the table has none).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical names of the tables.

    .PARAMETER SolutionUniqueName
    Existing unmanaged solution holding the tables, exported instead of a temporary one.

    .PARAMETER PublisherUniqueName
    Publisher of the temporary solution. Ignored when SolutionUniqueName is given. (Default: organization default publisher)

    .PARAMETER OutputPath
    Work folder for the export. (Default: TEMP folder)

    .OUTPUTS
    PSCustomObject[]. EntityLogicalName, RibbonDiffXml.

    .EXAMPLE
    $ribbons = Get-XrmRibbon -XrmClient $xrmClient -EntityLogicalName "account", "contact", "lead";
    $ribbons | ForEach-Object { "$($_.EntityLogicalName): $($_.RibbonDiffXml.CustomActions.ChildNodes.Count) custom actions" };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmRibbon.md
#>
function Get-XrmRibbon {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PublisherUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $OutputPath = [System.IO.Path]::GetTempPath()
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $useTempSolution = (-not $PSBoundParameters.ContainsKey('SolutionUniqueName'));
        $tempSolutionName = "RibbonExport_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
        $tempSolutionCreated = $false;
        $solutionFilePath = $null;
        $extractPath = $null;
        $exportedSolution = $SolutionUniqueName;
        try {
            if ($useTempSolution) {
                if ($PSBoundParameters.ContainsKey('PublisherUniqueName')) {
                    $publisher = $XrmClient | Get-XrmPublisher -PublisherUniqueName $PublisherUniqueName;
                    if (-not $publisher) {
                        throw "Publisher '$PublisherUniqueName' not found.";
                    }
                    $publisherRef = $publisher.Reference;
                }
                else {
                    $defaultSolution = $XrmClient | Get-XrmSolution -SolutionUniqueName "Default" -Columns "publisherid";
                    $publisherRef = $defaultSolution.publisherid_Value;
                }
                $exportedSolution = $tempSolutionName;
                $XrmClient | Add-XrmSolution -DisplayName $tempSolutionName -UniqueName $tempSolutionName -PublisherReference $publisherRef | Out-Null;
                $tempSolutionCreated = $true;
                foreach ($tableName in $EntityLogicalName) {
                    $entityMetadata = $XrmClient | Get-XrmEntityMetadata -LogicalName $tableName -Filter Entity;
                    $XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $tempSolutionName -ComponentId $entityMetadata.MetadataId -ComponentType 1 -DoNotIncludeSubcomponents $true | Out-Null;
                }
            }

            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $exportedSolution -Managed $false -ExportPath $OutputPath;
            $extractPath = Join-Path $OutputPath "RibbonExtract_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
            Expand-Archive -Path $solutionFilePath -DestinationPath $extractPath -Force;
            $customizationsPath = Join-Path $extractPath "customizations.xml";
            if (-not (Test-Path $customizationsPath)) {
                throw "customizations.xml not found in exported solution.";
            }
            [xml]$customizationsXml = Get-Content -Path $customizationsPath -Raw;

            foreach ($tableName in $EntityLogicalName) {
                $entityNode = $customizationsXml.ImportExportXml.Entities.Entity | Where-Object { $_.EntityInfo.entity.Name -eq $tableName };
                if (-not $entityNode) {
                    throw "Entity '$tableName' not found in the exported solution '$exportedSolution'.";
                }
                [PSCustomObject]@{
                    EntityLogicalName = $tableName;
                    RibbonDiffXml     = $entityNode.SelectSingleNode("RibbonDiffXml");
                };
            }
        }
        finally {
            # Cleanup temp solution: a cleanup failure is reported but does not hide the original error
            if ($tempSolutionCreated) {
                try {
                    $XrmClient | Uninstall-XrmSolution -SolutionUniqueName $tempSolutionName;
                }
                catch {
                    Write-Warning "Temporary solution '$tempSolutionName' was not removed: $($_.Exception.Message)";
                }
            }
            if ($extractPath -and (Test-Path $extractPath)) {
                Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue;
            }
            if ($useTempSolution -and $solutionFilePath -and (Test-Path $solutionFilePath)) {
                Remove-Item -Path $solutionFilePath -Force -ErrorAction SilentlyContinue;
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmRibbon -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmRibbon -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

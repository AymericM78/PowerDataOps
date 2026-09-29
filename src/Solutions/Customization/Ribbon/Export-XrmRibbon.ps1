<#
    .SYNOPSIS
    Export the ribbon customization XML for a table.

    .DESCRIPTION
    Export the RibbonDiffXml for a specific table by creating a temporary solution containing the table,
    exporting the solution, extracting the customizations.xml, and parsing the RibbonDiffXml node.
    This allows reading and modifying classic ribbon customizations programmatically.
    The temporary solution uses the publisher given by PublisherUniqueName, or the organization default publisher (publisher of the Default solution). It is removed at the end, even on failure.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the table whose ribbon to export.

    .PARAMETER SolutionUniqueName
    Existing solution unique name containing the table. If provided, exports from this solution instead of creating a temporary one.

    .PARAMETER PublisherUniqueName
    Publisher of the temporary solution. Ignored when SolutionUniqueName is given. (Default: organization default publisher)

    .PARAMETER OutputPath
    Folder path where extracted files will be stored. Optional. Defaults to temp folder.

    .OUTPUTS
    System.Xml.XmlElement. The RibbonDiffXml node for the specified entity.

    .EXAMPLE
    $ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
    $ribbonXml = Export-XrmRibbon -EntityLogicalName "contact" -SolutionUniqueName "MySolution";

    .EXAMPLE
    $ribbonXml = Export-XrmRibbon -XrmClient $xrmClient -EntityLogicalName "account" -PublisherUniqueName "contoso";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/customize-commands-ribbon
#>
function Export-XrmRibbon {
    [CmdletBinding()]
    [OutputType([System.Xml.XmlElement])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PublisherUniqueName,

        [Parameter(Mandatory = $false)]
        [string]
        $OutputPath = $env:TEMP
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

        try {
            if ($useTempSolution) {
                # Create temporary solution
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
                $SolutionUniqueName = $tempSolutionName;

                $XrmClient | Add-XrmSolution -DisplayName $tempSolutionName -UniqueName $tempSolutionName -PublisherReference $publisherRef | Out-Null;
                $tempSolutionCreated = $true;

                # Add entity to solution (ComponentType 1 = Entity)
                $entityMetadata = $XrmClient | Get-XrmEntityMetadata -LogicalName $EntityLogicalName;
                $XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $tempSolutionName -ComponentId $entityMetadata.MetadataId -ComponentType 1 -DoNotIncludeSubcomponents $true | Out-Null;
            }

            # Export solution
            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $SolutionUniqueName -Managed $false -ExportPath $OutputPath;

            # Extract zip
            $extractPath = Join-Path $OutputPath "RibbonExtract_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
            Expand-Archive -Path $solutionFilePath -DestinationPath $extractPath -Force;

            # Parse customizations.xml
            $customizationsPath = Join-Path $extractPath "customizations.xml";
            if (-not (Test-Path $customizationsPath)) {
                throw "customizations.xml not found in exported solution.";
            }

            [xml]$customizationsXml = Get-Content -Path $customizationsPath -Raw;

            # Find the entity node
            $entityNode = $customizationsXml.ImportExportXml.Entities.Entity | Where-Object {
                $_.EntityInfo.entity.Name -eq $EntityLogicalName;
            };

            if (-not $entityNode) {
                throw "Entity '$EntityLogicalName' not found in customizations.xml.";
            }

            $ribbonDiffXml = $entityNode.RibbonDiffXml;
            $ribbonDiffXml;
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

            # Cleanup extracted files
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

Export-ModuleMember -Function Export-XrmRibbon -Alias *;

Register-ArgumentCompleter -CommandName Export-XrmRibbon -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

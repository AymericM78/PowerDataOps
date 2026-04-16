<#
    .SYNOPSIS
    Export the ribbon customization XML for a table.

    .DESCRIPTION
    Export the RibbonDiffXml for a specific table by creating a temporary solution containing the table,
    exporting the solution, extracting the customizations.xml, and parsing the RibbonDiffXml node.
    This allows reading and modifying classic ribbon customizations programmatically.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the table whose ribbon to export.

    .PARAMETER SolutionUniqueName
    Existing solution unique name containing the table. If provided, exports from this solution instead of creating a temporary one.

    .PARAMETER OutputPath
    Folder path where extracted files will be stored. Optional. Defaults to temp folder.

    .OUTPUTS
    System.Xml.XmlElement. The RibbonDiffXml node for the specified entity.

    .EXAMPLE
    $ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
    $ribbonXml = Export-XrmRibbon -EntityLogicalName "contact" -SolutionUniqueName "MySolution";

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

        if ($useTempSolution) {
            # Create temporary solution
            $publisher = Get-XrmPublisher | Select-Object -First 1;
            $publisherRef = $publisher.Reference;
            $SolutionUniqueName = $tempSolutionName;

            New-XrmSolution -DisplayName $tempSolutionName -UniqueName $tempSolutionName -PublisherReference $publisherRef | Out-Null;

            # Add entity to solution (ComponentType 1 = Entity)
            $entityMetadata = Get-XrmEntityMetadata -LogicalName $EntityLogicalName;
            Add-XrmSolutionComponent -SolutionUniqueName $tempSolutionName -ComponentId $entityMetadata.MetadataId -ComponentType 1 -DoNotIncludeSubcomponents $true | Out-Null;
        }

        try {
            # Export solution
            $solutionFilePath = Export-XrmSolution -SolutionUniqueName $SolutionUniqueName -Managed $false -ExportPath $OutputPath;

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
            # Cleanup temp solution
            if ($useTempSolution) {
                $tempSolution = Get-XrmSolution -SolutionUniqueName $tempSolutionName;
                if ($tempSolution) {
                    Uninstall-XrmSolution -SolutionUniqueName $tempSolutionName;
                }
            }

            # Cleanup extracted files
            if ((Test-Path $extractPath)) {
                Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue;
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

<#
    .SYNOPSIS
    Import ribbon customization XML for a table.

    .DESCRIPTION
    Import a modified RibbonDiffXml for a specific table by creating a temporary solution containing the table,
    exporting the solution, replacing the RibbonDiffXml node in customizations.xml, re-zipping, and importing.
    This allows modifying classic ribbon customizations (commands, display rules, enable rules) programmatically.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the table whose ribbon to update.

    .PARAMETER RibbonDiffXml
    The RibbonDiffXml content as string or XmlElement containing CustomActions, CommandDefinitions, RuleDefinitions, etc.

    .PARAMETER SolutionUniqueName
    Existing solution unique name to use for import. If provided, uses this solution instead of creating a temporary one.

    .PARAMETER Publish
    Publish customizations after import. Default: true.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
    # Modify $ribbonXml as needed...
    Import-XrmRibbon -EntityLogicalName "account" -RibbonDiffXml $ribbonXml.OuterXml;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/customize-commands-ribbon
#>
function Import-XrmRibbon {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RibbonDiffXml,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $Publish = $true
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $workPath = Join-Path $env:TEMP "RibbonImport_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
        $useTempSolution = (-not $PSBoundParameters.ContainsKey('SolutionUniqueName'));
        $tempSolutionName = "RibbonImport_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";

        if ($useTempSolution) {
            $publisher = Get-XrmPublisher | Select-Object -First 1;
            $publisherRef = $publisher.Reference;
            $SolutionUniqueName = $tempSolutionName;

            Add-XrmSolution -DisplayName $tempSolutionName -UniqueName $tempSolutionName -PublisherReference $publisherRef | Out-Null;

            $entityMetadata = Get-XrmEntityMetadata -LogicalName $EntityLogicalName;
            Add-XrmSolutionComponent -SolutionUniqueName $tempSolutionName -ComponentId $entityMetadata.MetadataId -ComponentType 1 -DoNotIncludeSubcomponents $true | Out-Null;
        }

        try {
            # Export solution
            $solutionFilePath = Export-XrmSolution -SolutionUniqueName $SolutionUniqueName -Managed $false -ExportPath $env:TEMP;

            # Extract zip
            Expand-Archive -Path $solutionFilePath -DestinationPath $workPath -Force;

            # Modify customizations.xml
            $customizationsPath = Join-Path $workPath "customizations.xml";
            if (-not (Test-Path $customizationsPath)) {
                throw "customizations.xml not found in exported solution.";
            }

            [xml]$customizationsXml = Get-Content -Path $customizationsPath -Raw;

            $entityNode = $customizationsXml.ImportExportXml.Entities.Entity | Where-Object {
                $_.EntityInfo.entity.Name -eq $EntityLogicalName;
            };

            if (-not $entityNode) {
                throw "Entity '$EntityLogicalName' not found in customizations.xml.";
            }

            # Replace RibbonDiffXml
            [xml]$ribbonFragment = "<RibbonDiffXml>$RibbonDiffXml</RibbonDiffXml>";
            if ($RibbonDiffXml.TrimStart().StartsWith("<RibbonDiffXml")) {
                [xml]$ribbonFragment = $RibbonDiffXml;
            }

            $importedNode = $customizationsXml.ImportNode($ribbonFragment.DocumentElement, $true);
            $oldRibbonNode = $entityNode.SelectSingleNode("RibbonDiffXml");
            if ($oldRibbonNode) {
                $entityNode.ReplaceChild($importedNode, $oldRibbonNode) | Out-Null;
            }
            else {
                $entityNode.AppendChild($importedNode) | Out-Null;
            }

            $customizationsXml.Save($customizationsPath);

            # Re-zip
            $importZipPath = Join-Path $env:TEMP "$($SolutionUniqueName)_ribbon.zip";
            if (Test-Path $importZipPath) {
                Remove-Item -Path $importZipPath -Force;
            }
            [System.IO.Compression.ZipFile]::CreateFromDirectory($workPath, $importZipPath);

            # Import solution
            Import-XrmSolution -SolutionUniqueName $SolutionUniqueName -SolutionFilePath $importZipPath -OverwriteUnmanagedCustomizations $true;

            # Publish
            if ($Publish) {
                Publish-XrmCustomizations;
            }
        }
        finally {
            # Cleanup temp solution
            if ($useTempSolution) {
                $tempSolution = Get-XrmSolution -SolutionUniqueName $tempSolutionName;
                if ($tempSolution) {
                    Uninstall-XrmSolution -SolutionUniqueName $tempSolutionName;
                }
            }

            # Cleanup work files
            if ((Test-Path $workPath)) {
                Remove-Item -Path $workPath -Recurse -Force -ErrorAction SilentlyContinue;
            }
            if ((Test-Path $importZipPath)) {
                Remove-Item -Path $importZipPath -Force -ErrorAction SilentlyContinue;
            }
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Import-XrmRibbon -Alias *;

Register-ArgumentCompleter -CommandName Import-XrmRibbon -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

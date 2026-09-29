<#
    .SYNOPSIS
    Import ribbon customization XML for a table.

    .DESCRIPTION
    Import a modified RibbonDiffXml for a specific table by creating a temporary solution containing the table,
    exporting the solution, replacing the RibbonDiffXml node in customizations.xml, re-zipping, and importing.
    This allows modifying classic ribbon customizations (commands, display rules, enable rules) programmatically.
    The temporary solution uses the publisher given by PublisherUniqueName, or the organization default publisher (publisher of the Default solution). It is removed at the end, even on failure.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Logical name of the table whose ribbon to update.

    .PARAMETER RibbonDiffXml
    The RibbonDiffXml content, as a string or as an XmlElement (e.g. the output of Export-XrmRibbon), containing CustomActions, CommandDefinitions, RuleDefinitions, etc.

    .PARAMETER SolutionUniqueName
    Existing solution unique name to use for import. If provided, uses this solution instead of creating a temporary one.

    .PARAMETER PublisherUniqueName
    Publisher of the temporary solution. Ignored when SolutionUniqueName is given. (Default: organization default publisher)

    .PARAMETER Publish
    Publish customizations after import. Default: true.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    $ribbonXml = Export-XrmRibbon -EntityLogicalName "account";
    # Modify $ribbonXml as needed...
    Import-XrmRibbon -EntityLogicalName "account" -RibbonDiffXml $ribbonXml;

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
        [object]
        $RibbonDiffXml,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $Publish = $true,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PublisherUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        # An XmlElement converted to [string] gives its type name, not its XML
        $ribbonXmlText = if ($RibbonDiffXml -is [System.Xml.XmlNode]) { $RibbonDiffXml.OuterXml } else { [string]$RibbonDiffXml };

        $workPath = Join-Path $env:TEMP "RibbonImport_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
        $useTempSolution = (-not $PSBoundParameters.ContainsKey('SolutionUniqueName'));
        $tempSolutionName = "RibbonImport_$([Guid]::NewGuid().ToString('N').Substring(0, 8))";
        $tempSolutionCreated = $false;
        $solutionFilePath = $null;
        $importZipPath = $null;

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
                $SolutionUniqueName = $tempSolutionName;

                $XrmClient | Add-XrmSolution -DisplayName $tempSolutionName -UniqueName $tempSolutionName -PublisherReference $publisherRef | Out-Null;
                $tempSolutionCreated = $true;

                $entityMetadata = $XrmClient | Get-XrmEntityMetadata -LogicalName $EntityLogicalName;
                $XrmClient | Add-XrmSolutionComponent -SolutionUniqueName $tempSolutionName -ComponentId $entityMetadata.MetadataId -ComponentType 1 -DoNotIncludeSubcomponents $true | Out-Null;
            }

            # Export solution
            $solutionFilePath = $XrmClient | Export-XrmSolution -SolutionUniqueName $SolutionUniqueName -Managed $false -ExportPath $env:TEMP;

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
            if ($ribbonXmlText.TrimStart().StartsWith("<RibbonDiffXml")) {
                [xml]$ribbonFragment = $ribbonXmlText;
            }
            else {
                [xml]$ribbonFragment = "<RibbonDiffXml>$ribbonXmlText</RibbonDiffXml>";
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
            $XrmClient | Import-XrmSolution -SolutionUniqueName $SolutionUniqueName -SolutionFilePath $importZipPath -OverwriteUnmanagedCustomizations $true;

            # Publish
            if ($Publish) {
                $XrmClient | Publish-XrmCustomizations;
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

            # Cleanup work files
            if (Test-Path $workPath) {
                Remove-Item -Path $workPath -Recurse -Force -ErrorAction SilentlyContinue;
            }
            if ($importZipPath -and (Test-Path $importZipPath)) {
                Remove-Item -Path $importZipPath -Force -ErrorAction SilentlyContinue;
            }
            if ($solutionFilePath -and (Test-Path $solutionFilePath)) {
                Remove-Item -Path $solutionFilePath -Force -ErrorAction SilentlyContinue;
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

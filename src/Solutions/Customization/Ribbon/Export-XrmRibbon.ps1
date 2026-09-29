<#
    .SYNOPSIS
    Export the ribbon customization XML for a table.

    .DESCRIPTION
    Export the RibbonDiffXml for a specific table by creating a temporary solution containing the table,
    exporting the solution, extracting the customizations.xml, and parsing the RibbonDiffXml node.
    This allows reading and modifying classic ribbon customizations programmatically.
    The temporary solution uses the publisher given by PublisherUniqueName, or the organization default publisher (publisher of the Default solution). It is removed at the end, even on failure.
    For several tables, Get-XrmRibbon reads them all with one export.

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
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmRibbon.md
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
        $OutputPath = $env:TEMP,

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
        $ribbonParameters = @{ XrmClient = $XrmClient; EntityLogicalName = @($EntityLogicalName); OutputPath = $OutputPath };
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName') -and $SolutionUniqueName) {
            $ribbonParameters["SolutionUniqueName"] = $SolutionUniqueName;
        }
        if ($PSBoundParameters.ContainsKey('PublisherUniqueName')) {
            $ribbonParameters["PublisherUniqueName"] = $PublisherUniqueName;
        }
        $ribbon = Get-XrmRibbon @ribbonParameters;
        $ribbon.RibbonDiffXml;
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

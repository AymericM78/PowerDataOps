<#
    .SYNOPSIS
    Set or remove the visualization of a column in grids.

    .DESCRIPTION
    Show a column as a small chart in the grid cells (column visualization of the maker portal: heat map, radial dial...), or go back to plain text with Remove.
    The setting is a controlconfiguration row linked to the column, as the maker portal writes it: name CustomRenderersConfiguration, unique name msdyn_<table>_<column>_customrenderers, metadatajson {"type":"<renderer id>"}. It is created, or updated when the column already has one.
    With SolutionUniqueName, the row is added to the solution under the component type of controlconfiguration in this organization (read by Get-XrmSolutionComponentType: the code differs between organizations).
    The organization must have the controlconfiguration table (column visualization preview), else the command fails.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER LogicalName
    Column / Attribute logical name. Alias: AttributeLogicalName.

    .PARAMETER RendererId
    Renderer id, as the maker portal stores it in controlconfiguration.metadatajson (read it once from a column set in the portal).

    .PARAMETER Remove
    Remove the visualization (plain text). Nothing happens when the column has none.

    .PARAMETER SolutionUniqueName
    Unmanaged solution to add the configuration to.

    .PARAMETER Cache
    Hashtable owned by the caller and reused across calls: the component type of controlconfiguration is read once (see Get-XrmSolutionComponentType).

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. The controlconfiguration row. Nothing with Remove.

    .EXAMPLE
    $cache = @{};
    Set-XrmColumnVisualization -XrmClient $xrmClient -EntityLogicalName "new_project" -LogicalName "new_progress" -RendererId $heatMapRendererId -SolutionUniqueName "ContosoCore" -Cache $cache;

    .EXAMPLE
    Set-XrmColumnVisualization -XrmClient $xrmClient -EntityLogicalName "new_project" -LogicalName "new_progress" -Remove;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmColumnVisualization.md
#>
function Set-XrmColumnVisualization {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Set")]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("AttributeLogicalName")]
        [String]
        $LogicalName,

        [Parameter(Mandatory = $true, ParameterSetName = "Set")]
        [Guid]
        $RendererId,

        [Parameter(Mandatory = $true, ParameterSetName = "Remove")]
        [switch]
        $Remove,

        [Parameter(Mandatory = $false, ParameterSetName = "Set")]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false, ParameterSetName = "Set")]
        [Hashtable]
        $Cache
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not (Get-XrmEntityMetadata -XrmClient $XrmClient -LogicalName "controlconfiguration" -Filter Entity -IfExists)) {
            throw "Column visualizations are not available in this organization: the table 'controlconfiguration' does not exist.";
        }
        $column = Get-XrmColumn -XrmClient $XrmClient -EntityLogicalName $EntityLogicalName -LogicalName $LogicalName;

        $query = New-XrmQueryExpression -LogicalName "controlconfiguration" -Columns "metadatajson" |
            Add-XrmQueryCondition -Field "entitylogicalname" -Condition Equal -Values $EntityLogicalName |
            Add-XrmQueryCondition -Field "name" -Condition Equal -Values "CustomRenderersConfiguration" |
            Add-XrmQueryCondition -Field "attribute" -Condition Equal -Values $column.MetadataId;
        $existing = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query -AsEntity -AsArray;

        if ($Remove) {
            foreach ($row in $existing) {
                Remove-XrmRecord -XrmClient $XrmClient -LogicalName "controlconfiguration" -Id $row.Id;
            }
            return;
        }

        $metadataJson = "{`"type`":`"$($RendererId.ToString())`"}";
        if ($existing.Count -gt 0) {
            $configurationId = $existing[0].Id;
            if ($existing[0]["metadatajson"] -ne $metadataJson) {
                $record = New-XrmEntity -LogicalName "controlconfiguration" -Id $configurationId -Attributes @{ "metadatajson" = $metadataJson };
                Update-XrmRecord -XrmClient $XrmClient -Record $record;
            }
        }
        else {
            # Same names as the maker portal
            $record = New-XrmEntity -LogicalName "controlconfiguration" -Attributes @{
                "uniquename"        = "msdyn_$($EntityLogicalName)_$($LogicalName)_customrenderers";
                "name"              = "CustomRenderersConfiguration";
                "entitylogicalname" = $EntityLogicalName;
                "attribute"         = New-XrmEntityReference -LogicalName "attribute" -Id $column.MetadataId;
                "metadatajson"      = $metadataJson;
            };
            $configurationId = Add-XrmRecord -XrmClient $XrmClient -Record $record;
            if (-not $configurationId) {
                return;
            }
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $typeParams = @{ XrmClient = $XrmClient; LogicalName = "controlconfiguration" };
            if ($PSBoundParameters.ContainsKey('Cache')) {
                $typeParams["Cache"] = $Cache;
            }
            $componentType = Get-XrmSolutionComponentType @typeParams;
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $configurationId -ComponentType $componentType | Out-Null;
        }

        New-XrmEntityReference -LogicalName "controlconfiguration" -Id $configurationId;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmColumnVisualization -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmColumnVisualization -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

Register-ArgumentCompleter -CommandName Set-XrmColumnVisualization -ParameterName "LogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    if (-not ($FakeBoundParameters.ContainsKey("EntityLogicalName"))) {
        return @();
    }
    $validAttributeNames = Get-XrmAttributesLogicalName -EntityLogicalName $FakeBoundParameters.EntityLogicalName;
    return $validAttributeNames | Where-Object { $_ -like "$wordToComplete*" };
}

<#
    .SYNOPSIS
    Create or update a chart in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a savedqueryvisualization record (system chart) by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    Chart (savedqueryvisualization) Id used as the upsert key.

    .PARAMETER EntityLogicalName
    Table / Entity logical name the chart belongs to.

    .PARAMETER Name
    Chart display name.

    .PARAMETER DataDescription
    Data description XML defining the chart data source.

    .PARAMETER PresentationDescription
    Presentation description XML defining the chart visual.

    .PARAMETER Description
    Chart description.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the chart is added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedqueryvisualization record.

    .EXAMPLE
    $ref = Upsert-XrmChart -Id $chartId -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml -SolutionUniqueName "MySolution";
#>
function Upsert-XrmChart {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $Id,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DataDescription,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PresentationDescription,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attributes = @{
            "primaryentitytypecode"   = $EntityLogicalName;
            "name"                    = $Name;
            "datadescription"         = $DataDescription;
            "presentationdescription" = $PresentationDescription;
        };
        if ($PSBoundParameters.ContainsKey('Description')) {
            $attributes["description"] = $Description;
        }

        $record = New-XrmEntity -LogicalName "savedqueryvisualization" -Id $Id -Attributes $attributes;

        $XrmClient | Upsert-XrmRecord -Record $record | Out-Null;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 59 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        New-XrmEntityReference -LogicalName "savedqueryvisualization" -Id $Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmChart -Alias *;

Register-ArgumentCompleter -CommandName Upsert-XrmChart -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

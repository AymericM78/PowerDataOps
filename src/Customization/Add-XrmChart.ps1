<#
    .SYNOPSIS
    Create a new chart in Microsoft Dataverse.

    .DESCRIPTION
    Create a new savedqueryvisualization record (system chart).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

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

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created savedqueryvisualization record.

    .EXAMPLE
    $ref = Add-XrmChart -EntityLogicalName "account" -Name "Revenue Chart" -DataDescription $dataXml -PresentationDescription $presXml;
#>
function Add-XrmChart {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
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
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "savedqueryvisualization" -Attributes @{
            "primaryentitytypecode"  = $EntityLogicalName;
            "name"                   = $Name;
            "datadescription"        = $DataDescription;
            "presentationdescription" = $PresentationDescription;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        $id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        New-XrmEntityReference -LogicalName "savedqueryvisualization" -Id $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmChart -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmChart -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

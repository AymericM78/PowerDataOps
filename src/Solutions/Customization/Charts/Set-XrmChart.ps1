<#
    .SYNOPSIS
    Update a chart in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing savedqueryvisualization record (system chart).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ChartReference
    EntityReference of the savedqueryvisualization to update.

    .PARAMETER Name
    Updated chart display name.

    .PARAMETER DataDescription
    Updated data description XML.

    .PARAMETER PresentationDescription
    Updated presentation description XML.

    .PARAMETER Description
    Updated description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated savedqueryvisualization record.

    .EXAMPLE
    Set-XrmChart -ChartReference $chartRef -Name "Updated Revenue Chart";
#>
function Set-XrmChart {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $ChartReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $DataDescription,

        [Parameter(Mandatory = $false)]
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
        $record = New-XrmEntity -LogicalName "savedqueryvisualization" -Id $ChartReference.Id;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $record.Attributes["name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('DataDescription')) {
            $record.Attributes["datadescription"] = $DataDescription;
        }
        if ($PSBoundParameters.ContainsKey('PresentationDescription')) {
            $record.Attributes["presentationdescription"] = $PresentationDescription;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        Update-XrmRecord -XrmClient $XrmClient -Record $record;
        $ChartReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmChart -Alias *;

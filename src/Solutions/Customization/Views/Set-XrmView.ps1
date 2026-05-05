<#
    .SYNOPSIS
    Update a view in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing savedquery record (system view).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER ViewReference
    EntityReference of the savedquery to update.

    .PARAMETER Name
    Updated view display name.

    .PARAMETER FetchXml
    Updated FetchXml query.

    .PARAMETER LayoutXml
    Updated Layout XML.

    .PARAMETER Description
    Updated description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the updated savedquery record.

    .EXAMPLE
    Set-XrmView -ViewReference $viewRef -Name "All Active Accounts" -FetchXml $newFetchXml;
#>
function Set-XrmView {
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
        $ViewReference,

        [Parameter(Mandatory = $false)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $FetchXml,

        [Parameter(Mandatory = $false)]
        [string]
        $LayoutXml,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "savedquery" -Id $ViewReference.Id;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $record.Attributes["name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('FetchXml')) {
            $record.Attributes["fetchxml"] = $FetchXml;
        }
        if ($PSBoundParameters.ContainsKey('LayoutXml')) {
            $record.Attributes["layoutxml"] = $LayoutXml;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        Update-XrmRecord -XrmClient $XrmClient -Record $record;
        $ViewReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmView -Alias *;

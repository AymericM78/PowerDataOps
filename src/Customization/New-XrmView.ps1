<#
    .SYNOPSIS
    Create a new view in Microsoft Dataverse.

    .DESCRIPTION
    Create a new savedquery record (system view).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name the view belongs to.

    .PARAMETER Name
    View display name.

    .PARAMETER FetchXml
    FetchXml query for the view.

    .PARAMETER LayoutXml
    Layout XML defining column widths and order.

    .PARAMETER QueryType
    View query type. Default: 0 (public view).

    .PARAMETER Description
    View description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created savedquery record.

    .EXAMPLE
    $ref = New-XrmView -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml;
#>
function New-XrmView {
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
        $FetchXml,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LayoutXml,

        [Parameter(Mandatory = $false)]
        [int]
        $QueryType = 0,

        [Parameter(Mandatory = $false)]
        [string]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "savedquery" -Attributes @{
            "returnedtypecode" = $EntityLogicalName;
            "name"             = $Name;
            "fetchxml"         = $FetchXml;
            "layoutxml"        = $LayoutXml;
            "querytype"        = $QueryType;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record.Attributes["description"] = $Description;
        }

        $id = Add-XrmRecord -XrmClient $XrmClient -Record $record;
        New-XrmEntityReference -LogicalName "savedquery" -Id $id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmView -Alias *;

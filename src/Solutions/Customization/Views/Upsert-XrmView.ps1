<#
    .SYNOPSIS
    Create or update a view in Microsoft Dataverse.

    .DESCRIPTION
    Upsert a savedquery record (system view) by Id using the Upsert SDK message. If the record exists it is updated; otherwise it is created with the provided Id. Delegates to Upsert-XrmRecord.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    View (savedquery) Id used as the upsert key.

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

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the view is added to this solution.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedquery record.

    .EXAMPLE
    $ref = Upsert-XrmView -Id $viewId -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -SolutionUniqueName "MySolution";
#>
function Upsert-XrmView {
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
            "returnedtypecode" = $EntityLogicalName;
            "name"             = $Name;
            "fetchxml"         = $FetchXml;
            "layoutxml"        = $LayoutXml;
            "querytype"        = $QueryType;
        };
        if ($PSBoundParameters.ContainsKey('Description')) {
            $attributes["description"] = $Description;
        }

        $record = New-XrmEntity -LogicalName "savedquery" -Id $Id -Attributes $attributes;

        $XrmClient | Upsert-XrmRecord -Record $record | Out-Null;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 26 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        New-XrmEntityReference -LogicalName "savedquery" -Id $Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmView -Alias *;

Register-ArgumentCompleter -CommandName Upsert-XrmView -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

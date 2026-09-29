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

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Example: @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

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

    .PARAMETER IsDefault
    Make the view the default one of its type for the table. With $true, the flag is cleared on the previous default views of the same table and type (the platform keeps it otherwise).

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted savedquery record.

    .EXAMPLE
    $ref = Upsert-XrmView -Id $viewId -EntityLogicalName "account" -Name "Active Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -SolutionUniqueName "MySolution";

    .EXAMPLE
    $ref = Upsert-XrmView -XrmClient $xrmClient -Id $viewId -EntityLogicalName "account" -Name "My Accounts" -FetchXml $fetchXml -LayoutXml $layoutXml -IsDefault $true;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmView.md
#>
function Upsert-XrmView {
    [CmdletBinding(DefaultParameterSetName = "ByName", SupportsShouldProcess)]
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

        [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = "ByLabels")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

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
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsDefault
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            $Name = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }

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
        if ($PSBoundParameters.ContainsKey('IsDefault')) {
            $attributes["isdefault"] = $IsDefault;
        }

        $record = New-XrmEntity -LogicalName "savedquery" -Id $Id -Attributes $attributes;

        $XrmClient | Upsert-XrmRecord -Record $record | Out-Null;
        $viewReference = New-XrmEntityReference -LogicalName "savedquery" -Id $Id;

        # The platform keeps the previous default view flagged: clear it, one default per table and view type
        if ($PSBoundParameters.ContainsKey('IsDefault') -and $IsDefault) {
            $previousDefaults = @(Get-XrmViews -XrmClient $XrmClient -EntityLogicalName $EntityLogicalName -QueryType $QueryType -IsDefault -Columns "savedqueryid" | Where-Object { $_.Id -ne $Id });
            foreach ($previousDefault in $previousDefaults) {
                $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "savedquery" -Id $previousDefault.Id -Attributes @{ isdefault = $false });
            }
        }

        # Persist the multilingual name as real translations (SetLocLabels) so each language sees its own label.
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $viewReference -AttributeName "name" -Labels $Labels | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 26 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        $viewReference;
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

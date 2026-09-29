<#
    .SYNOPSIS
    Retrieve savedquery records.

    .DESCRIPTION
    Get all saved query according to entity name and predefined columns.
    Use -Unpublished to also retrieve views that are in draft state.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Gets or sets the entity name in order to filter views name.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER Unpublished
    When specified, uses RetrieveUnpublishedMultiple to include views in draft (unpublished) state.
    Without this switch only published views are returned.

    .PARAMETER QueryType
    View types to keep (savedquery.querytype, see the SavedQueryQueryType values): 0 public view, 1 advanced find, 2 associated (subgrid), 4 quick find, 64 lookup... (Default: all)

    .PARAMETER IsDefault
    Keep the default views only (isdefault true): with QueryType 0, the default public view of the table.

    .OUTPUTS
    PSCustomObject[]. Array of savedquery records (XrmObject).

    .EXAMPLE
    $views = Get-XrmViews -EntityLogicalName "account";

    .EXAMPLE
    # Include unpublished drafts
    $allViews = Get-XrmViews -EntityLogicalName "account" -Unpublished;

    .EXAMPLE
    # Default public view and quick find view
    $defaultView = Get-XrmViews -XrmClient $xrmClient -EntityLogicalName "account" -QueryType 0 -IsDefault -Columns "name", "fetchxml";
    $quickFind = Get-XrmViews -XrmClient $xrmClient -EntityLogicalName "account" -QueryType 4 -Columns "name";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmViews.md
#>
function Get-XrmViews {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("*"),

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpublished,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $QueryType,

        [Parameter(Mandatory = $false)]
        [switch]
        $IsDefault
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $queryViews = New-XrmQueryExpression -LogicalName "savedquery" -Columns $Columns;
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $queryViews = $queryViews | Add-XrmQueryCondition -Field "returnedtypecode" -Condition Equal -Values $EntityLogicalName;
        }
        if ($PSBoundParameters.ContainsKey('QueryType')) {
            $queryViews = $queryViews | Add-XrmQueryCondition -Field "querytype" -Condition In -Values $QueryType;
        }
        if ($IsDefault) {
            $queryViews = $queryViews | Add-XrmQueryCondition -Field "isdefault" -Condition Equal -Values $true;
        }

        $XrmClient | Get-XrmMultipleComponents -Query $queryViews -Unpublished:$Unpublished;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmViews -Alias *;

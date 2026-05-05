<#
    .SYNOPSIS
    Retrieve model-driven app records from Microsoft Dataverse.

    .DESCRIPTION
    Get appmodule records (model-driven apps) with optional name filter.
    Use -Unpublished to also retrieve apps that are in draft state.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    App display name filter. Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER Unpublished
    When specified, uses RetrieveUnpublishedMultiple to include apps that are in draft
    (unpublished) state. Without this switch only published apps are returned.

    .OUTPUTS
    PSCustomObject[]. Array of appmodule records (XrmObject).

    .EXAMPLE
    $apps = Get-XrmAppModules;
    $app = Get-XrmAppModules -Name "Sales Hub";

    .EXAMPLE
    # Include unpublished drafts
    $allApps = Get-XrmAppModules -Unpublished;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest#operations
#>
function Get-XrmAppModules {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Columns = @("*"),

        [Parameter(Mandatory = $false)]
        [switch]
        $Unpublished
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "appmodule" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $query = $query | Add-XrmQueryCondition -Field "name" -Condition Equal -Values $Name;
        }

        if ($Unpublished) {
            $request = New-XrmRequest -Name "RetrieveUnpublishedMultiple";
            $request | Add-XrmRequestParameter -Name "Query" -Value $query | Out-Null;
            $response = Protect-XrmCommand -ScriptBlock { $XrmClient.Execute($request) };
            $response["EntityCollection"].Entities | ConvertTo-XrmObjects;
        }
        else {
            $XrmClient | Get-XrmMultipleRecords -Query $query;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAppModules -Alias *;

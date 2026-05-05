<#
    .SYNOPSIS
    Retrieve security roles assigned to a model-driven app.

    .DESCRIPTION
    Get the list of security roles that have access to a given model-driven app,
    via the appmoduleroles_association N:N relationship.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleReference
    Reference to the appmodule record.

    .PARAMETER Columns
    Specify expected columns to retrieve from the role entity. (Default : roleid, name, businessunitid)

    .OUTPUTS
    PSCustomObject[]. Array of role records (XrmObject) assigned to the app.

    .EXAMPLE
    $appRef = Get-XrmAppModules -Name "My App" | Select-Object -First 1 | ForEach-Object { $_.Reference };
    $roles = Get-XrmAppModuleRoles -AppModuleReference $appRef;

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest
#>
function Get-XrmAppModuleRoles {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $AppModuleReference,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Columns = @("roleid", "name", "businessunitid")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "role" -Columns $Columns;

        $link = $query | Add-XrmQueryLink -ToEntityName "appmoduleroles" -FromAttributeName "roleid" -ToAttributeName "roleid" -JoinOperator Inner;
        $link | Add-XrmQueryLinkCondition -Field "appmoduleid" -Condition Equal -Values @($AppModuleReference.Id) | Out-Null;

        $XrmClient | Get-XrmMultipleRecords -Query $query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmAppModuleRoles -Alias *;

<#
    .SYNOPSIS
    Retrieve connection roles from Microsoft Dataverse.

    .DESCRIPTION
    Get connectionrole records with optional name or category filter.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Connection role name filter. Optional.

    .PARAMETER Category
    Connection role category value filter. Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    Microsoft.Xrm.Sdk.Entity[]. Array of connectionrole records.

    .EXAMPLE
    $roles = Get-XrmConnectionRoles;
    $roles = Get-XrmConnectionRoles -Name "Stakeholder";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/describe-relationship-entities-connection-roles
#>
function Get-XrmConnectionRoles {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Entity[]])]
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
        [int]
        $Category,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Columns = @("*")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "connectionrole" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $query = $query | Add-XrmQueryCondition -Field "name" -Condition Equal -Values $Name;
        }
        if ($PSBoundParameters.ContainsKey('Category')) {
            $query = $query | Add-XrmQueryCondition -Field "category" -Condition Equal -Values $Category;
        }

        $roles = $XrmClient | Get-XrmMultipleRecords -Query $query;
        $roles;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmConnectionRoles -Alias *;

<#
    .SYNOPSIS
    Retrieve publishers.

    .DESCRIPTION
    Get every publisher of the organization, optionally the custom ones only (publishers created in the organization: not readonly, not the platform ones).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : id, uniquename, friendlyname, customizationprefix, customizationoptionvalueprefix, isreadonly)

    .PARAMETER CustomOnly
    Keep the publishers that are not read-only (isreadonly false).

    .OUTPUTS
    PSCustomObject[]. Publisher rows (XrmObject).

    .EXAMPLE
    Get-XrmPublishers -XrmClient $xrmClient -CustomOnly | Select-Object uniquename, customizationprefix;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmPublishers.md
#>
function Get-XrmPublishers {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("publisherid", "uniquename", "friendlyname", "customizationprefix", "customizationoptionvalueprefix", "isreadonly"),

        [Parameter(Mandatory = $false)]
        [switch]
        $CustomOnly
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "publisher" -Columns $Columns;
        if ($CustomOnly) {
            $query = $query | Add-XrmQueryCondition -Field "isreadonly" -Condition Equal -Values $false;
        }
        $query = $query | Add-XrmQueryOrder -Field "uniquename" -OrderType Ascending;
        $XrmClient | Get-XrmMultipleRecords -Query $query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmPublishers -Alias *;

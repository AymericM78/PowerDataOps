<#
    .SYNOPSIS
    Retrieve command records from Microsoft Dataverse.

    .DESCRIPTION
    Get appaction records (command bar buttons) optionally filtered by entity context.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name to filter commands by context entity. Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .OUTPUTS
    PSCustomObject[]. Array of appaction records (XrmObject).

    .EXAMPLE
    $commands = Get-XrmCommands;
    $accountCommands = Get-XrmCommands -EntityLogicalName "account";
#>
function Get-XrmCommands {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [string]
        $EntityLogicalName,

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
        $query = New-XrmQueryExpression -LogicalName "appaction" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $query = $query | Add-XrmQueryCondition -Field "contextentity" -Condition Equal -Values $EntityLogicalName;
        }

        $commands = $XrmClient | Get-XrmMultipleRecords -Query $query;
        $commands;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmCommands -Alias *;

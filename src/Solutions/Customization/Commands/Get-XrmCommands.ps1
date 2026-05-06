<#
    .SYNOPSIS
    Retrieve command records from Microsoft Dataverse.

    .DESCRIPTION
    Get appaction records (command bar buttons) optionally filtered by entity context.
    Use -Unpublished to also retrieve commands that are in draft state.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name to filter commands by context entity. Optional.

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : all columns)

    .PARAMETER Unpublished
    When specified, uses RetrieveUnpublishedMultiple to include commands in draft (unpublished) state.
    Without this switch only published commands are returned.

    .OUTPUTS
    PSCustomObject[]. Array of appaction records (XrmObject).

    .EXAMPLE
    $commands = Get-XrmCommands;
    $accountCommands = Get-XrmCommands -EntityLogicalName "account";

    .EXAMPLE
    # Include unpublished drafts
    $allCommands = Get-XrmCommands -Unpublished;
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
        $query = New-XrmQueryExpression -LogicalName "appaction" -Columns $Columns;

        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $query = $query | Add-XrmQueryCondition -Field "contextentity" -Condition Equal -Values $EntityLogicalName;
        }

        $XrmClient | Get-XrmMultipleComponents -Query $query -Unpublished:$Unpublished;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmCommands -Alias *;

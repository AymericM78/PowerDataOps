<#
    .SYNOPSIS
    Retrieve the Dataverse triggers registered by cloud flows.

    .DESCRIPTION
    Read the callback registrations (callbackregistration) that the "When a row is added, modified or deleted" trigger creates when a flow is turned on.
    Each row gives the table (entityname), the change type (message: added, deleted, modified, or a combination), the scope, the filtering columns and the filter expression.
    The callback URL is not read by default: it grants access to the flow.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table logical name. (Default: all)

    .PARAMETER Columns
    Columns to return. (Default: name, entityname, message, sdkmessagename, scope, filteringattributes, filterexpression, runas, softdeletestatus, createdon)

    .OUTPUTS
    PSCustomObject[]. Callback registration rows (XrmObject).

    .EXAMPLE
    $triggers = Get-XrmFlowTriggers -XrmClient $xrmClient -EntityLogicalName "account";
    $triggers | Select-Object name, message, filteringattributes;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmFlowTriggers.md
#>
function Get-XrmFlowTriggers {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("name", "entityname", "message", "sdkmessagename", "scope", "filteringattributes", "filterexpression", "runas", "softdeletestatus", "createdon")
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $query = New-XrmQueryExpression -LogicalName "callbackregistration" -Columns $Columns;
        if ($PSBoundParameters.ContainsKey('EntityLogicalName')) {
            $query = $query | Add-XrmQueryCondition -Field "entityname" -Condition Equal -Values $EntityLogicalName;
        }
        $XrmClient | Get-XrmMultipleRecords -Query $query;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmFlowTriggers -Alias *;

Register-ArgumentCompleter -CommandName Get-XrmFlowTriggers -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

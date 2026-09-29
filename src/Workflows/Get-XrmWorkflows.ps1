<#
    .SYNOPSIS
    Retrieve workflows.

    .DESCRIPTION
    Get workflows (processes: classic workflows, business rules, actions, business process flows, cloud flows...) with expected columns, optionally filtered.
    Processes of the Basic solution are excluded, as before.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Columns
    Specify expected columns to retrieve. (Default : "name", "category", "primaryentity", "uniquename", "statecode", "statuscode")

    .PARAMETER Category
    Process categories to keep: 0 Workflow, 1 Dialog, 2 Business rule, 3 Action, 4 Business process flow, 5 Cloud flow (modern flow), 6 Desktop flow, 7 AI flow. (Default: all)

    .PARAMETER Type
    Process types to keep: 1 Definition, 2 Activation, 3 Template. (Default: all)

    .PARAMETER PrimaryEntity
    Logical name of the table the process runs on. (Default: all)

    .PARAMETER State
    States to keep: 0 Draft, 1 Activated, 2 Suspended. (Default: all)

    .PARAMETER Name
    Process name. Wildcards * are accepted (e.g. "Contoso*"). (Default: all)

    .OUTPUTS
    PSCustomObject[]. Workflow rows (XrmObject).

    .EXAMPLE
    $workflows = Get-XrmWorkflows -XrmClient $xrmClient;

    .EXAMPLE
    # Activated cloud flows on account
    $flows = Get-XrmWorkflows -XrmClient $xrmClient -Category 5 -State 1 -PrimaryEntity "account" -Columns "name", "clientdata";

    .EXAMPLE
    $definitions = Get-XrmWorkflows -XrmClient $xrmClient -Type 1 -Name "Contoso*";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmWorkflows.md
#>
function Get-XrmWorkflows {
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
        $Columns = @( "name", "category", "primaryentity", "uniquename", "statecode", "statuscode"),

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Category,

        [Parameter(Mandatory = $false)]
        [ValidateSet(1, 2, 3)]
        [int[]]
        $Type,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PrimaryEntity,

        [Parameter(Mandatory = $false)]
        [ValidateSet(0, 1, 2)]
        [int[]]
        $State,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $basicSolution = Get-XrmBasicSolution -XrmClient $XrmClient -Columns "solutionid";

        $queryProcess = New-XrmQueryExpression -LogicalName "workflow" -Columns $Columns;
        $queryProcess = $queryProcess | Add-XrmQueryCondition -Field solutionid -Condition NotEqual -Values $basicSolution.Id;
        if ($PSBoundParameters.ContainsKey('Category')) {
            $queryProcess = $queryProcess | Add-XrmQueryCondition -Field "category" -Condition In -Values $Category;
        }
        if ($PSBoundParameters.ContainsKey('Type')) {
            $queryProcess = $queryProcess | Add-XrmQueryCondition -Field "type" -Condition In -Values $Type;
        }
        if ($PSBoundParameters.ContainsKey('PrimaryEntity')) {
            $queryProcess = $queryProcess | Add-XrmQueryCondition -Field "primaryentity" -Condition Equal -Values $PrimaryEntity;
        }
        if ($PSBoundParameters.ContainsKey('State')) {
            $queryProcess = $queryProcess | Add-XrmQueryCondition -Field "statecode" -Condition In -Values $State;
        }
        if ($PSBoundParameters.ContainsKey('Name')) {
            if ($Name.Contains("*")) {
                $queryProcess = $queryProcess | Add-XrmQueryCondition -Field "name" -Condition Like -Values $Name.Replace("*", "%");
            }
            else {
                $queryProcess = $queryProcess | Add-XrmQueryCondition -Field "name" -Condition Equal -Values $Name;
            }
        }

        $workflows = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $queryProcess;
        $workflows;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmWorkflows -Alias *;

<#
    .SYNOPSIS
    Check whether a component belongs to a solution.

    .DESCRIPTION
    Look for the component in the solution components (solutioncomponent) of the given solution.
    Raises an error when the solution does not exist.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SolutionUniqueName
    Solution unique name.

    .PARAMETER ComponentId
    Component unique identifier (objectid: the MetadataId for tables and columns, the row id for the other components).

    .PARAMETER ComponentType
    Solution component type code (see Get-XrmSolutionComponentType).

    .OUTPUTS
    System.Boolean. True when the component is in the solution.

    .EXAMPLE
    $viewType = Get-XrmSolutionComponentType -XrmClient $xrmClient -LogicalName "savedquery";
    if (-not (Test-XrmSolutionComponent -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentId $viewId -ComponentType $viewType)) {
        Add-XrmSolutionComponent -XrmClient $xrmClient -SolutionUniqueName "MySolution" -ComponentId $viewId -ComponentType $viewType;
    }

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Test-XrmSolutionComponent.md
#>
function Test-XrmSolutionComponent {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $true)]
        [int]
        $ComponentType
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $solution = Get-XrmSolution -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -Columns "solutionid";
        if (-not $solution) {
            throw "Solution '$SolutionUniqueName' not found.";
        }

        $query = New-XrmQueryExpression -LogicalName "solutioncomponent" -Columns "solutioncomponentid" -TopCount 1;
        $query = $query | Add-XrmQueryCondition -Field "solutionid" -Condition Equal -Values $solution.Id;
        $query = $query | Add-XrmQueryCondition -Field "objectid" -Condition Equal -Values $ComponentId;
        $query = $query | Add-XrmQueryCondition -Field "componenttype" -Condition Equal -Values $ComponentType;
        $components = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity -AsArray;
        $components.Count -gt 0;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Test-XrmSolutionComponent -Alias *;

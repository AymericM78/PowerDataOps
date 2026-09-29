<#
    .SYNOPSIS
    Move a component from one unmanaged solution to another.

    .DESCRIPTION
    Add the component to the target solution, check that it is there, then remove it from the source solution.
    The component itself is not changed: only its membership moves.
    Raises an error, before any change, when the component is not in the source solution; and, before removing it from the source, when the target solution does not list it after the addition.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER SourceSolutionUniqueName
    Unmanaged solution the component leaves.

    .PARAMETER TargetSolutionUniqueName
    Unmanaged solution the component joins.

    .PARAMETER ComponentId
    Component unique identifier (objectid).

    .PARAMETER ComponentType
    Solution component type code (see Get-XrmSolutionComponentType).

    .PARAMETER DoNotIncludeSubcomponents
    Passed to Add-XrmSolutionComponent. (Default: true for a table, false otherwise)

    .PARAMETER AddRequiredComponents
    Passed to Add-XrmSolutionComponent. (Default: false)

    .OUTPUTS
    PSCustomObject. ComponentId, ComponentType, SourceSolutionUniqueName, TargetSolutionUniqueName.

    .EXAMPLE
    Move-XrmSolutionComponent -XrmClient $xrmClient -From "Staging" -To "Core" -ComponentId $viewId -ComponentType 26;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Move-XrmSolutionComponent.md
#>
function Move-XrmSolutionComponent {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("From")]
        [String]
        $SourceSolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("To")]
        [String]
        $TargetSolutionUniqueName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $ComponentId,

        [Parameter(Mandatory = $true)]
        [int]
        $ComponentType,

        [Parameter(Mandatory = $false)]
        [bool]
        $DoNotIncludeSubcomponents,

        [Parameter(Mandatory = $false)]
        [bool]
        $AddRequiredComponents = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $component = "Component $ComponentId (type $ComponentType)";
        if (-not (Test-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SourceSolutionUniqueName -ComponentId $ComponentId -ComponentType $ComponentType)) {
            throw "$component is not in solution '$SourceSolutionUniqueName'.";
        }

        $addParameters = @{
            XrmClient             = $XrmClient;
            SolutionUniqueName    = $TargetSolutionUniqueName;
            ComponentId           = $ComponentId;
            ComponentType         = $ComponentType;
            AddRequiredComponents = $AddRequiredComponents;
        };
        if ($PSBoundParameters.ContainsKey('DoNotIncludeSubcomponents')) {
            $addParameters["DoNotIncludeSubcomponents"] = $DoNotIncludeSubcomponents;
        }
        Add-XrmSolutionComponent @addParameters | Out-Null;

        if (-not $WhatIfPreference) {
            if (-not (Test-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $TargetSolutionUniqueName -ComponentId $ComponentId -ComponentType $ComponentType)) {
                throw "$component was not added to solution '$TargetSolutionUniqueName': it stays in '$SourceSolutionUniqueName'.";
            }
        }
        try {
            Remove-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SourceSolutionUniqueName -ComponentId $ComponentId -ComponentType $ComponentType -ErrorAction Stop | Out-Null;
        }
        catch {
            throw "$component was added to '$TargetSolutionUniqueName' but could not be removed from '$SourceSolutionUniqueName': $($_.Exception.Message)";
        }
        if ($WhatIfPreference) {
            return;
        }

        [PSCustomObject]@{
            ComponentId              = $ComponentId;
            ComponentType            = $ComponentType;
            SourceSolutionUniqueName = $SourceSolutionUniqueName;
            TargetSolutionUniqueName = $TargetSolutionUniqueName;
        };
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Move-XrmSolutionComponent -Alias *;

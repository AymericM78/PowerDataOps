<#
    .SYNOPSIS
    Create a CascadeConfiguration object for a one-to-many relationship.

    .DESCRIPTION
    Build the cascading behavior of a 1:N relationship (what happens to the child rows when the parent row is assigned, deleted, shared...).
    Only the given actions are set: with Set-XrmRelationship, the other actions keep their current value; with a new relationship, the platform applies its defaults.
    Values: Cascade (all), Active (active rows only), UserOwned (rows owned by the same user), NoCascade, RemoveLink (delete only), Restrict (delete only).

    .PARAMETER Assign
    Behavior when the parent row is assigned.

    .PARAMETER Delete
    Behavior when the parent row is deleted: Cascade, RemoveLink or Restrict.

    .PARAMETER Merge
    Behavior when the parent row is merged: Cascade or NoCascade.

    .PARAMETER Reparent
    Behavior when the parent row changes owner through its own parent.

    .PARAMETER Share
    Behavior when the parent row is shared.

    .PARAMETER Unshare
    Behavior when the parent row is unshared.

    .PARAMETER RollupView
    Behavior of the rollup views: Cascade, Active, UserOwned or NoCascade.

    .PARAMETER Archive
    Behavior when the parent row is archived (long term retention): Cascade, RemoveLink, Restrict or NoCascade.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.CascadeConfiguration.

    .EXAMPLE
    # Parental behavior
    $cascade = New-XrmCascadeConfiguration -Assign Cascade -Delete Cascade -Merge Cascade -Reparent Cascade -Share Cascade -Unshare Cascade -RollupView NoCascade;

    .EXAMPLE
    # Block the deletion of a parent that still has children
    Set-XrmRelationship -XrmClient $xrmClient -Name "new_project_task" -CascadeConfiguration (New-XrmCascadeConfiguration -Delete Restrict);

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmCascadeConfiguration.md
#>
function New-XrmCascadeConfiguration {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.CascadeConfiguration])]
    param
    (
        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Assign,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Delete,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Merge,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Reparent,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Share,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Unshare,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $RollupView,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.CascadeType]
        $Archive
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $cascade = [Microsoft.Xrm.Sdk.Metadata.CascadeConfiguration]::new();
        foreach ($action in "Assign", "Delete", "Merge", "Reparent", "Share", "Unshare", "RollupView", "Archive") {
            if ($PSBoundParameters.ContainsKey($action)) {
                $cascade.$action = $PSBoundParameters[$action];
            }
        }
        $cascade;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmCascadeConfiguration -Alias *;

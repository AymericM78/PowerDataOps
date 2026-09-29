<#
    .SYNOPSIS
    Create an AssociatedMenuConfiguration object for a relationship.

    .DESCRIPTION
    Build how the related rows appear in the navigation of the parent form (classic "Related" menu): behavior, group, label and order.
    Only the given properties are set: with Set-XrmRelationship, the others keep their current value.

    .PARAMETER Behavior
    UseCollectionName (plural name of the related table), UseLabel (Label below) or DoNotDisplay.

    .PARAMETER Group
    Details, Sales, Service or Marketing.

    .PARAMETER Label
    Menu label, with Behavior UseLabel (single language, see LanguageCode).

    .PARAMETER Labels
    Menu label by language code (e.g. @{ 1033 = "Tasks"; 1036 = "Taches" }), instead of Label.

    .PARAMETER LanguageCode
    Language of Label. (Default: 1033)

    .PARAMETER Order
    Position in the group.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration.

    .EXAMPLE
    $menu = New-XrmAssociatedMenuConfiguration -Behavior UseLabel -Group Details -Labels @{ 1033 = "Project tasks"; 1036 = "Taches du projet" } -Order 10000;
    Set-XrmRelationship -XrmClient $xrmClient -Name "new_project_task" -AssociatedMenuConfiguration $menu;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/New-XrmAssociatedMenuConfiguration.md
#>
function New-XrmAssociatedMenuConfiguration {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration])]
    param
    (
        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuBehavior]
        $Behavior,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuGroup]
        $Group,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $Label,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $false)]
        [int]
        $Order
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $menu = [Microsoft.Xrm.Sdk.Metadata.AssociatedMenuConfiguration]::new();
        if ($PSBoundParameters.ContainsKey('Behavior')) { $menu.Behavior = $Behavior; }
        if ($PSBoundParameters.ContainsKey('Group')) { $menu.Group = $Group; }
        if ($PSBoundParameters.ContainsKey('Order')) { $menu.Order = $Order; }
        if ($PSBoundParameters.ContainsKey('Labels')) {
            $menu.Label = New-XrmLabel -Labels $Labels;
        }
        elseif ($PSBoundParameters.ContainsKey('Label')) {
            $menu.Label = New-XrmLabel -Text $Label -LanguageCode $LanguageCode;
        }
        $menu;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmAssociatedMenuConfiguration -Alias *;

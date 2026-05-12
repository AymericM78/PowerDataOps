<#
    .SYNOPSIS
    Update a model-driven app in Microsoft Dataverse.

    .DESCRIPTION
    Update appmodule record properties (name, description, icon).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER AppModuleReference
    EntityReference of the appmodule record to update.

    .PARAMETER Name
    New display name. Optional.

    .PARAMETER Description
    New description. Optional.

    .PARAMETER WebResourceId
    New web resource icon Id. Optional.

    .PARAMETER SolutionUniqueName
    Unmanaged solution unique name. When provided, the updated app is automatically added to this solution.

    .OUTPUTS
    System.Void.

    .EXAMPLE
    Set-XrmAppModule -AppModuleReference $appRef -Name "Renamed App" -Description "Updated description";
    Set-XrmAppModule -AppModuleReference $appRef -Name "Renamed App" -SolutionUniqueName "MySolution";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/model-driven-apps/create-manage-model-driven-apps-using-code
#>
function Set-XrmAppModule {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $AppModuleReference,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [Guid]
        $WebResourceId,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "appmodule";
        $record.Id = $AppModuleReference.Id;

        if ($PSBoundParameters.ContainsKey('Name')) {
            $record["name"] = $Name;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record["description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('WebResourceId')) {
            $record["webresourceid"] = $WebResourceId;
        }

        $XrmClient | Update-XrmRecord -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $AppModuleReference.Id -ComponentType 80 -DoNotIncludeSubcomponents $false | Out-Null;
        }
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmAppModule -Alias *;

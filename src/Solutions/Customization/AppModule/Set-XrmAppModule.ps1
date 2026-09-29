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

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and each language is set as a translation (SetLocLabels). -Name takes precedence for the stored name if both are provided.

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

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
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmAppModule.md
#>
function Set-XrmAppModule {
    [CmdletBinding(SupportsShouldProcess)]
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
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

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
        elseif ($PSBoundParameters.ContainsKey('Labels')) {
            $record["name"] = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $record["description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('WebResourceId')) {
            $record["webresourceid"] = $WebResourceId;
        }

        $XrmClient | Update-XrmRecord -Record $record;

        # The translations are set even when -Name gives the stored name
        if ($PSBoundParameters.ContainsKey('Labels')) {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $AppModuleReference -AttributeName "name" -Labels $Labels | Out-Null;
        }

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

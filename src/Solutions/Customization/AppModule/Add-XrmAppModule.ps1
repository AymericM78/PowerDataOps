<#
    .SYNOPSIS
    Create a new model-driven app in Microsoft Dataverse.

    .DESCRIPTION
    Create a new appmodule record (model-driven app) with the specified name and properties.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Display name for the app.

    .PARAMETER UniqueName
    Unique name for the app (auto-prefixed with publisher prefix).

    .PARAMETER Description
    App description. Optional.

    .PARAMETER WebResourceId
    Id of the web resource to use as app icon. Optional.

    .PARAMETER PublisherReference
    Reference to the publisher that owns the app. Optional.

    .PARAMETER ClientType
    Client type bitmask. Optional. Common values: 1 = Web legacy, 4 = Unified Client Interface (default for new apps).

    .PARAMETER FormFactor
    Form factor bitmask. Optional. Common values: 1 = Desktop, 2 = Tablet, 4 = Phone. Can be combined (e.g. 3 = Desktop + Tablet).

    .PARAMETER NavigationType
    Navigation type for the app. Optional. 0 = Single session (SiteMap-based), 1 = Multi-session.

    .PARAMETER IsDefault
    Whether this is the default app for the organization. Optional. Defaults to false.

    .PARAMETER IsFeatured
    Whether the app is featured in the app picker. Optional. Defaults to false.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the app to. Optional.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the created appmodule record.

    .EXAMPLE
    $appRef = Add-XrmAppModule -Name "My Custom App" -UniqueName "myapp";

    .EXAMPLE
    $pubRef = Get-XrmPublisher -PublisherUniqueName "mypublisher";
    $appRef = Add-XrmAppModule -Name "My App" -UniqueName "myapp" -PublisherReference $pubRef.Reference -ClientType 4 -FormFactor 1 -NavigationType 0 -SolutionUniqueName "MySolution";

    .LINK
    https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/appmodule?view=dataverse-latest
#>
function Add-XrmAppModule {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $UniqueName,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [Guid]
        $WebResourceId,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.EntityReference]
        $PublisherReference,

        [Parameter(Mandatory = $false)]
        [int]
        $ClientType,

        [Parameter(Mandatory = $false)]
        [int]
        $FormFactor,

        [Parameter(Mandatory = $false)]
        [int]
        $NavigationType,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsDefault,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsFeatured,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $record = New-XrmEntity -LogicalName "appmodule" -Attributes @{
            "name"       = $Name;
            "uniquename" = $UniqueName;
        };

        if ($PSBoundParameters.ContainsKey('Description')) {
            $record["description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('WebResourceId')) {
            $record["webresourceid"] = $WebResourceId;
        }
        if ($PSBoundParameters.ContainsKey('PublisherReference')) {
            $record["publisherid"] = $PublisherReference;
        }
        if ($PSBoundParameters.ContainsKey('ClientType')) {
            $record["clienttype"] = $ClientType;
        }
        if ($PSBoundParameters.ContainsKey('FormFactor')) {
            $record["formfactor"] = $FormFactor;
        }
        if ($PSBoundParameters.ContainsKey('NavigationType')) {
            $record["navigationtype"] = New-XrmOptionSetValue -Value $NavigationType;
        }
        if ($PSBoundParameters.ContainsKey('IsDefault')) {
            $record["isdefault"] = $IsDefault;
        }
        if ($PSBoundParameters.ContainsKey('IsFeatured')) {
            $record["isfeatured"] = $IsFeatured;
        }

        $record.Id = $XrmClient | Add-XrmRecord -Record $record;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -SolutionUniqueName $SolutionUniqueName -ComponentId $record.Id -ComponentType 80 -DoNotIncludeSubcomponents $false;
        }

        $record.ToEntityReference();
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Add-XrmAppModule -Alias *;

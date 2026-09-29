<#
    .SYNOPSIS
    Create or update a model-driven app in Microsoft Dataverse.

    .DESCRIPTION
    Create or update an appmodule record by Id: when the app exists, published or not (a new app stays unpublished until it is published), it is updated; otherwise it is created with the provided Id.
    The SDK Upsert message is not used: it does not see unpublished apps and tries to create them again.
    With -Labels, the name is also set in each language (SetLocLabels).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Id
    App (appmodule) Id used as the upsert key.

    .PARAMETER Name
    Display name for the app.

    .PARAMETER Labels
    Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code), and each language is set as a translation. Example: @{ 1033 = "My App"; 1036 = "Mon application" }

    .PARAMETER LanguageCode
    Language code used to pick the stored 'name' from -Labels. Default: 1033.

    .PARAMETER UniqueName
    Unique name for the app.

    .PARAMETER Description
    App description. Optional.

    .PARAMETER WebResourceId
    Id of the web resource to use as app icon. Optional.

    .PARAMETER PublisherReference
    Reference to the publisher that owns the app. Optional.

    .PARAMETER ClientType
    Client type bitmask. Optional.

    .PARAMETER FormFactor
    Form factor bitmask. Optional.

    .PARAMETER NavigationType
    Navigation type for the app. Optional.

    .PARAMETER IsDefault
    Whether this is the default app for the organization. Optional.

    .PARAMETER IsFeatured
    Whether the app is featured in the app picker. Optional.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the app to. Optional.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted appmodule record.

    .EXAMPLE
    $appRef = Upsert-XrmAppModule -Id $appId -Name "My Custom App" -UniqueName "myapp" -SolutionUniqueName "MySolution";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmAppModule.md
#>
function Upsert-XrmAppModule {
    [CmdletBinding(DefaultParameterSetName = "ByName", SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = "ByLabels")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

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
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            $Name = Get-XrmLabelText -Labels $Labels -LanguageCode $LanguageCode;
        }

        $attributes = @{
            "name"       = $Name;
            "uniquename" = $UniqueName;
        };
        if ($PSBoundParameters.ContainsKey('Description')) {
            $attributes["description"] = $Description;
        }
        if ($PSBoundParameters.ContainsKey('WebResourceId')) {
            $attributes["webresourceid"] = $WebResourceId;
        }
        if ($PSBoundParameters.ContainsKey('PublisherReference')) {
            $attributes["publisherid"] = $PublisherReference;
        }
        if ($PSBoundParameters.ContainsKey('ClientType')) {
            $attributes["clienttype"] = $ClientType;
        }
        if ($PSBoundParameters.ContainsKey('FormFactor')) {
            $attributes["formfactor"] = $FormFactor;
        }
        if ($PSBoundParameters.ContainsKey('NavigationType')) {
            $attributes["navigationtype"] = (New-XrmOptionSetValue -Value $NavigationType);
        }
        if ($PSBoundParameters.ContainsKey('IsDefault')) {
            $attributes["isdefault"] = $IsDefault;
        }
        if ($PSBoundParameters.ContainsKey('IsFeatured')) {
            $attributes["isfeatured"] = $IsFeatured;
        }

        $record = New-XrmEntity -LogicalName "appmodule" -Id $Id -Attributes $attributes;

        $existing = @(Get-XrmAppModules -XrmClient $XrmClient -Id $Id -Columns "appmoduleid");
        if ($existing.Count -eq 0) {
            $existing = @(Get-XrmAppModules -XrmClient $XrmClient -Id $Id -Columns "appmoduleid" -Unpublished);
        }
        if ($existing.Count -gt 0) {
            $XrmClient | Update-XrmRecord -Record $record -ErrorAction Stop;
        }
        else {
            $XrmClient | Add-XrmRecord -Record $record -ErrorAction Stop | Out-Null;
        }
        if ($PSCmdlet.ParameterSetName -eq "ByLabels") {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker (New-XrmEntityReference -LogicalName "appmodule" -Id $Id) -AttributeName "name" -Labels $Labels | Out-Null;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            Add-XrmSolutionComponent -XrmClient $XrmClient -SolutionUniqueName $SolutionUniqueName -ComponentId $Id -ComponentType 80 -DoNotIncludeSubcomponents $false | Out-Null;
        }

        New-XrmEntityReference -LogicalName "appmodule" -Id $Id;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmAppModule -Alias *;

<#
    .SYNOPSIS
    Update a table in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing entity / table metadata using UpdateEntityRequest.
    Only the given properties are sent (minimal metadata): the platform validates every property the request carries, and leaves the others as they are.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER MetadataId
    The MetadataId (GUID) of the table to update. Either MetadataId or LogicalName is required.

    .PARAMETER DisplayName
    New display name for the table.

    .PARAMETER DisplayCollectionName
    New plural display name for the table.

    .PARAMETER OwnershipType
    Ownership type (UserOwned or OrganizationOwned).

    .PARAMETER IsActivity
    Whether the table is an activity entity.

    .PARAMETER HasNotes
    Whether the table has notes enabled.

    .PARAMETER HasActivities
    Whether the table has activities enabled.

    .PARAMETER IsAuditEnabled
    Whether auditing is enabled on the table.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .PARAMETER MergeLabels
    Whether to merge labels. Default: true. With DisplayNameLabels, PluralNameLabels or DescriptionLabels, the current labels of the other languages are read and sent too: the platform would otherwise copy the given text into the language of the caller when it is missing.

    .PARAMETER LanguageCode
    Language code for labels. Default: 1033.

    .PARAMETER DisplayNameLabels
    Hashtable of language code to display name for multilingual labels. Takes precedence over -DisplayName. Example: @{ 1033 = "Customer"; 1036 = "Client" }

    .PARAMETER PluralNameLabels
    Hashtable of language code to plural display name for multilingual labels. Takes precedence over -DisplayCollectionName.

    .PARAMETER DescriptionLabels
    Hashtable of language code to description for multilingual labels. Takes precedence over -Description.

    .PARAMETER IconVectorName
    Name of the vector icon to use for the table.

    .PARAMETER LogicalName
    Logical name of the table to update, instead of MetadataId.

    .PARAMETER IsQuickCreateEnabled
    Whether quick create forms are enabled.

    .PARAMETER IsConnectionsEnabled
    Whether connections are enabled.

    .PARAMETER IsDocumentManagementEnabled
    Whether SharePoint document management is enabled.

    .PARAMETER IsMailMergeEnabled
    Whether mail merge is enabled.

    .PARAMETER ChangeTrackingEnabled
    Whether change tracking is enabled.

    .PARAMETER SyncToExternalSearchIndex
    Whether the table is indexed by Dataverse search.

    .PARAMETER IsAvailableOffline
    Whether the table is available offline.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateEntity response.

    .EXAMPLE
    Set-XrmTable -MetadataId "00000000-0000-0000-0000-000000000001" -DisplayName "Customer" -DisplayCollectionName "Customers";

    .EXAMPLE
    Set-XrmTable -MetadataId $metadataId -DisplayNameLabels @{ 1033 = "Customer"; 1036 = "Client" } -PluralNameLabels @{ 1033 = "Customers"; 1036 = "Clients" };

    .EXAMPLE
    Set-XrmTable -XrmClient $xrmClient -LogicalName "new_project" -ChangeTrackingEnabled $true -IsQuickCreateEnabled $true;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmTable.md
#>
function Set-XrmTable {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [guid]
        $MetadataId,

        [Parameter(Mandatory = $false)]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [string]
        $DisplayCollectionName,

        [Parameter(Mandatory = $false)]
        [string]
        $Description = "",

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]
        $OwnershipType,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsActivity,

        [Parameter(Mandatory = $false)]
        [bool]
        $HasNotes,

        [Parameter(Mandatory = $false)]
        [bool]
        $HasActivities,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsAuditEnabled,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $DisplayNameLabels,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $PluralNameLabels,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $DescriptionLabels,

        [Parameter(Mandatory = $false)]
        [string]
        $IconVectorName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsQuickCreateEnabled,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsConnectionsEnabled,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsDocumentManagementEnabled,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsMailMergeEnabled,

        [Parameter(Mandatory = $false)]
        [bool]
        $ChangeTrackingEnabled,

        [Parameter(Mandatory = $false)]
        [bool]
        $SyncToExternalSearchIndex,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsAvailableOffline
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('MetadataId') -and -not $PSBoundParameters.ContainsKey('LogicalName')) {
            throw "MetadataId or LogicalName is required.";
        }
        $tableParams = @{ LanguageCode = $LanguageCode };
        foreach ($flag in "IsQuickCreateEnabled", "IsConnectionsEnabled", "IsDocumentManagementEnabled", "IsMailMergeEnabled", "ChangeTrackingEnabled", "SyncToExternalSearchIndex", "IsAvailableOffline") {
            if ($PSBoundParameters.ContainsKey($flag)) { $tableParams[$flag] = $PSBoundParameters[$flag]; }
        }
        if ($PSBoundParameters.ContainsKey('DisplayName')) { $tableParams['DisplayName'] = $DisplayName; }
        if ($PSBoundParameters.ContainsKey('DisplayCollectionName')) { $tableParams['PluralName'] = $DisplayCollectionName; }
        if ($PSBoundParameters.ContainsKey('Description')) { $tableParams['Description'] = $Description; }
        if ($PSBoundParameters.ContainsKey('OwnershipType')) { $tableParams['OwnershipType'] = $OwnershipType; }
        if ($PSBoundParameters.ContainsKey('IsActivity')) { $tableParams['IsActivity'] = $IsActivity; }
        if ($PSBoundParameters.ContainsKey('HasNotes')) { $tableParams['HasNotes'] = $HasNotes; }
        if ($PSBoundParameters.ContainsKey('HasActivities')) { $tableParams['HasActivities'] = $HasActivities; }
        if ($PSBoundParameters.ContainsKey('IsAuditEnabled')) { $tableParams['IsAuditEnabled'] = $IsAuditEnabled; }
        if ($PSBoundParameters.ContainsKey('IconVectorName')) { $tableParams['IconVectorName'] = $IconVectorName; }
        if ($PSBoundParameters.ContainsKey('DisplayNameLabels')) { $tableParams['DisplayNameLabels'] = $DisplayNameLabels; }
        if ($PSBoundParameters.ContainsKey('PluralNameLabels')) { $tableParams['PluralNameLabels'] = $PluralNameLabels; }
        if ($PSBoundParameters.ContainsKey('DescriptionLabels')) { $tableParams['DescriptionLabels'] = $DescriptionLabels; }

        # With MergeLabels, the languages not given are sent with their current text: the platform
        # otherwise copies the given text into the language of the caller when that one is missing
        $labelProperties = @{ DisplayNameLabels = "DisplayName"; PluralNameLabels = "DisplayCollectionName"; DescriptionLabels = "Description" };
        $givenLabels = @($labelProperties.Keys | Where-Object { $tableParams.ContainsKey($_) });
        if ($MergeLabels -and $givenLabels.Count -gt 0) {
            $retrieveRequest = [Microsoft.Xrm.Sdk.Messages.RetrieveEntityRequest]::new();
            $retrieveRequest.EntityFilters = [Microsoft.Xrm.Sdk.Metadata.EntityFilters]::Entity;
            $retrieveRequest.RetrieveAsIfPublished = $true;
            if ($PSBoundParameters.ContainsKey('LogicalName')) { $retrieveRequest.LogicalName = $LogicalName; } else { $retrieveRequest.MetadataId = $MetadataId; }
            $current = (Invoke-XrmRequest -XrmClient $XrmClient -Request $retrieveRequest -ErrorAction Stop).Results["EntityMetadata"];
            foreach ($parameterName in $givenLabels) {
                $merged = ConvertFrom-XrmLabel -Label $current.($labelProperties[$parameterName]);
                foreach ($languageCode in $tableParams[$parameterName].Keys) { $merged[[int]$languageCode] = $tableParams[$parameterName][$languageCode]; }
                $tableParams[$parameterName] = $merged;
            }
        }

        $entityMetadata = New-XrmTable @tableParams;
        if ($PSBoundParameters.ContainsKey('MetadataId')) { $entityMetadata.MetadataId = $MetadataId; }
        if ($PSBoundParameters.ContainsKey('LogicalName')) { $entityMetadata.LogicalName = $LogicalName; }

        $request = [Microsoft.Xrm.Sdk.Messages.UpdateEntityRequest]::new();
        $request.Entity = $entityMetadata;
        $request.MergeLabels = $MergeLabels;

        # Notes and activities are enabled through the request: the platform ignores them on the metadata
        if ($PSBoundParameters.ContainsKey('HasNotes')) { $request.HasNotes = $HasNotes; }
        if ($PSBoundParameters.ContainsKey('HasActivities')) { $request.HasActivities = $HasActivities; }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request.Parameters["SolutionUniqueName"] = $SolutionUniqueName;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmTable -Alias *;

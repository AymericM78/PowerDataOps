<#
    .SYNOPSIS
    Update a table in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing entity / table metadata using UpdateEntityRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER MetadataId
    The MetadataId (GUID) of the table to update.

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
    Whether to merge labels. Default: true.

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

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateEntity response.

    .EXAMPLE
    Set-XrmTable -MetadataId "00000000-0000-0000-0000-000000000001" -DisplayName "Customer" -DisplayCollectionName "Customers";

    .EXAMPLE
    Set-XrmTable -MetadataId $metadataId -DisplayNameLabels @{ 1033 = "Customer"; 1036 = "Client" } -PluralNameLabels @{ 1033 = "Customers"; 1036 = "Clients" };
#>
function Set-XrmTable {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
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
        $IconVectorName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $tableParams = @{ LanguageCode = $LanguageCode };
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

        $entityMetadata = New-XrmTable @tableParams;
        $entityMetadata.MetadataId = $MetadataId;

        $request = [Microsoft.Xrm.Sdk.Messages.UpdateEntityRequest]::new();
        $request.Entity = $entityMetadata;
        $request.MergeLabels = $MergeLabels;

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

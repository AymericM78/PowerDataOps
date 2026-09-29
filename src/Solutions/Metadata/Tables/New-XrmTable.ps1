<#
    .SYNOPSIS
    Build an EntityMetadata object for a Dataverse table.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.EntityMetadata object
    that can be passed to Add-XrmTable.

    .PARAMETER LogicalName
    Table / Entity logical name.

    .PARAMETER DisplayName
    Display name for the table.

    .PARAMETER PluralName
    Plural display name for the table.

    .PARAMETER Description
    Table description.

    .PARAMETER OwnershipType
    Ownership type (UserOwned or OrganizationOwned). Default: UserOwned.

    .PARAMETER HasNotes
    Whether the table has notes enabled. Default: false.

    .PARAMETER HasActivities
    Whether the table has activities enabled. Default: false.

    .PARAMETER IsActivity
    Whether the table is an activity entity. Default: false.

    .PARAMETER IsAuditEnabled
    Whether auditing is enabled on the table. Default: false.

    .PARAMETER LanguageCode
    Language code for labels. Default: 1033.

    .PARAMETER DisplayNameLabels
    Hashtable of language code to display name for multilingual labels. Takes precedence over -DisplayName. Example: @{ 1033 = "Project"; 1036 = "Projet" }

    .PARAMETER PluralNameLabels
    Hashtable of language code to plural display name for multilingual labels. Takes precedence over -PluralName.

    .PARAMETER DescriptionLabels
    Hashtable of language code to description for multilingual labels. Takes precedence over -Description.

    .PARAMETER IconVectorName
    Name of the vector icon to use for the table.

    .PARAMETER IsAvailableOffline
    Whether the table is available offline.

    .PARAMETER IsQuickCreateEnabled
    Whether quick create forms are enabled.

    .PARAMETER IsConnectionsEnabled
    Whether connections are enabled (BooleanManagedProperty).

    .PARAMETER IsDocumentManagementEnabled
    Whether SharePoint document management is enabled.

    .PARAMETER IsMailMergeEnabled
    Whether mail merge is enabled (BooleanManagedProperty).

    .PARAMETER ChangeTrackingEnabled
    Whether change tracking is enabled (required by some synchronizations).

    .PARAMETER SyncToExternalSearchIndex
    Whether the table is indexed by Dataverse search.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityMetadata. Only the given properties are set, so the object can serve a minimal update.

    .EXAMPLE
    # The metadata that Add-XrmTable and Set-XrmTable send
    $metadata = New-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects";

    .EXAMPLE
    $metadata = New-XrmTable -LogicalName "new_project" -DisplayNameLabels @{ 1033 = "Project"; 1036 = "Projet" } -PluralNameLabels @{ 1033 = "Projects"; 1036 = "Projets" };
#>
function New-XrmTable {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.EntityMetadata])]
    param
    (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PluralName,

        [Parameter(Mandatory = $false)]
        [string]
        $Description = "",

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]
        $OwnershipType = [Microsoft.Xrm.Sdk.Metadata.OwnershipTypes]::UserOwned,

        [Parameter(Mandatory = $false)]
        [bool]
        $HasNotes = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $HasActivities = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsActivity = $false,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsAuditEnabled = $false,

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
        [bool]
        $IsAvailableOffline,

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
        $SyncToExternalSearchIndex
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $entityMetadata = [Microsoft.Xrm.Sdk.Metadata.EntityMetadata]::new();

        if ($PSBoundParameters.ContainsKey('LogicalName')) {
            $entityMetadata.LogicalName = $LogicalName;
            $entityMetadata.SchemaName = $LogicalName;
        }

        if ($PSBoundParameters.ContainsKey('DisplayNameLabels')) {
            $entityMetadata.DisplayName = New-XrmLabel -Labels $DisplayNameLabels;
        }
        elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
            $entityMetadata.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        }

        if ($PSBoundParameters.ContainsKey('PluralNameLabels')) {
            $entityMetadata.DisplayCollectionName = New-XrmLabel -Labels $PluralNameLabels;
        }
        elseif ($PSBoundParameters.ContainsKey('PluralName')) {
            $entityMetadata.DisplayCollectionName = New-XrmLabel -Text $PluralName -LanguageCode $LanguageCode;
        }

        if ($PSBoundParameters.ContainsKey('OwnershipType')) {
            $entityMetadata.OwnershipType = $OwnershipType;
        }

        if ($PSBoundParameters.ContainsKey('IsActivity')) {
            $entityMetadata.IsActivity = $IsActivity;
        }

        if ($PSBoundParameters.ContainsKey('HasNotes')) {
            $entityMetadata.HasNotes = $HasNotes;
        }

        if ($PSBoundParameters.ContainsKey('HasActivities')) {
            $entityMetadata.HasActivities = $HasActivities;
        }

        if ($PSBoundParameters.ContainsKey('IsAuditEnabled')) {
            $entityMetadata.IsAuditEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($IsAuditEnabled);
        }

        if ($PSBoundParameters.ContainsKey('DescriptionLabels')) {
            $entityMetadata.Description = New-XrmLabel -Labels $DescriptionLabels;
        }
        elseif (-not [string]::IsNullOrWhiteSpace($Description)) {
            $entityMetadata.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
        }

        if ($PSBoundParameters.ContainsKey('IconVectorName')) {
            $entityMetadata.IconVectorName = $IconVectorName;
        }
        foreach ($flag in "IsAvailableOffline", "IsQuickCreateEnabled", "IsDocumentManagementEnabled", "ChangeTrackingEnabled", "SyncToExternalSearchIndex") {
            if ($PSBoundParameters.ContainsKey($flag)) {
                $entityMetadata.$flag = $PSBoundParameters[$flag];
            }
        }
        foreach ($managedFlag in "IsConnectionsEnabled", "IsMailMergeEnabled") {
            if ($PSBoundParameters.ContainsKey($managedFlag)) {
                $entityMetadata.$managedFlag = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($PSBoundParameters[$managedFlag]);
            }
        }

        $entityMetadata;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmTable -Alias *;

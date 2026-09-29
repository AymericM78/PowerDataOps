<#
    .SYNOPSIS
    Create a new table in Microsoft Dataverse.

    .DESCRIPTION
    Create a new entity / table using CreateEntityRequest.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER LogicalName
    Table / Entity logical name.

    .PARAMETER DisplayName
    Display name for the table. DisplayName or DisplayNameLabels is required.

    .PARAMETER PluralName
    Plural display name for the table. PluralName or PluralNameLabels is required.

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

    .PARAMETER PrimaryAttributeSchemaName
    Schema name for the primary attribute.

    .PARAMETER PrimaryAttributeDisplayName
    Display name for the primary attribute. PrimaryAttributeDisplayName or PrimaryAttributeDisplayNameLabels is required.

    .PARAMETER PrimaryAttributeMaxLength
    Max length of the primary attribute. Default: 100.

    .PARAMETER IsAuditEnabled
    Whether auditing is enabled on the table. Default: false.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the table to.

    .PARAMETER LanguageCode
    Language code for labels. Default: 1033.

    .PARAMETER DisplayNameLabels
    Hashtable of language code to display name for multilingual labels. Takes precedence over -DisplayName. Example: @{ 1033 = "Project"; 1036 = "Projet" }

    .PARAMETER PluralNameLabels
    Hashtable of language code to plural display name for multilingual labels. Takes precedence over -PluralName.

    .PARAMETER DescriptionLabels
    Hashtable of language code to description for multilingual labels. Takes precedence over -Description.

    .PARAMETER PrimaryAttributeDisplayNameLabels
    Hashtable of language code to primary attribute display name for multilingual labels. Takes precedence over -PrimaryAttributeDisplayName.

    .PARAMETER IconVectorName
    Name of the vector icon to use for the table.

    .PARAMETER IsAvailableOffline
    Whether the table is available offline. An activity table requires IsAvailableOffline and HasNotes set to true (checked before sending).

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

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateEntity response.

    .EXAMPLE
    $response = Add-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects" -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";

    .EXAMPLE
    $response = Add-XrmTable -LogicalName "new_project" -DisplayNameLabels @{ 1033 = "Project"; 1036 = "Projet" } -PluralNameLabels @{ 1033 = "Projects"; 1036 = "Projets" } -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayNameLabels @{ 1033 = "Name"; 1036 = "Nom" };

    .EXAMPLE
    # Activity table: the primary column of an activity is its subject
    $response = Add-XrmTable -LogicalName "new_visit" -DisplayName "Visit" -PluralName "Visits" -IsActivity $true -HasNotes $true -IsAvailableOffline $true -IsQuickCreateEnabled $true -PrimaryAttributeSchemaName "Subject" -PrimaryAttributeDisplayName "Subject";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Add-XrmTable.md
#>
function Add-XrmTable {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrimaryAttributeSchemaName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrimaryAttributeDisplayName,

        [Parameter(Mandatory = $false)]
        [int]
        $PrimaryAttributeMaxLength = 100,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsAuditEnabled = $false,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

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
        [Hashtable]
        $PrimaryAttributeDisplayNameLabels,

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
        # Platform rules for activity tables, checked before sending (the platform reports them one at a time)
        if ($IsActivity -and (-not $HasNotes -or -not $IsAvailableOffline)) {
            throw "An activity table requires -HasNotes `$true and -IsAvailableOffline `$true.";
        }
        # Each name is given as a single text or as labels by language
        foreach ($pair in @("DisplayName", "DisplayNameLabels"), @("PluralName", "PluralNameLabels"), @("PrimaryAttributeDisplayName", "PrimaryAttributeDisplayNameLabels")) {
            if (-not $PSBoundParameters.ContainsKey($pair[0]) -and -not $PSBoundParameters.ContainsKey($pair[1])) {
                throw "$($pair[0]) or $($pair[1]) is required.";
            }
        }
        $tableParams = @{
            LogicalName     = $LogicalName;
            Description     = $Description;
            OwnershipType   = $OwnershipType;
            HasNotes        = $HasNotes;
            HasActivities   = $HasActivities;
            IsActivity      = $IsActivity;
            IsAuditEnabled  = $IsAuditEnabled;
            LanguageCode    = $LanguageCode;
            IconVectorName  = $IconVectorName;
        };
        if ($PSBoundParameters.ContainsKey('DisplayName')) { $tableParams['DisplayName'] = $DisplayName; }
        if ($PSBoundParameters.ContainsKey('PluralName')) { $tableParams['PluralName'] = $PluralName; }
        if ($PSBoundParameters.ContainsKey('DisplayNameLabels')) { $tableParams['DisplayNameLabels'] = $DisplayNameLabels; }
        if ($PSBoundParameters.ContainsKey('PluralNameLabels')) { $tableParams['PluralNameLabels'] = $PluralNameLabels; }
        if ($PSBoundParameters.ContainsKey('DescriptionLabels')) { $tableParams['DescriptionLabels'] = $DescriptionLabels; }
        foreach ($flag in "IsAvailableOffline", "IsQuickCreateEnabled", "IsConnectionsEnabled", "IsDocumentManagementEnabled", "IsMailMergeEnabled", "ChangeTrackingEnabled", "SyncToExternalSearchIndex") {
            if ($PSBoundParameters.ContainsKey($flag)) { $tableParams[$flag] = $PSBoundParameters[$flag]; }
        }

        $entityMetadata = New-XrmTable @tableParams;

        $primaryAttribute = [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]::new();
        $primaryAttribute.SchemaName = $PrimaryAttributeSchemaName;
        $primaryAttribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::ApplicationRequired);
        $primaryAttribute.MaxLength = $PrimaryAttributeMaxLength;
        if ($PSBoundParameters.ContainsKey('PrimaryAttributeDisplayNameLabels')) {
            $primaryAttribute.DisplayName = New-XrmLabel -Labels $PrimaryAttributeDisplayNameLabels;
        }
        else {
            $primaryAttribute.DisplayName = New-XrmLabel -Text $PrimaryAttributeDisplayName -LanguageCode $LanguageCode;
        }

        $request = [Microsoft.Xrm.Sdk.Messages.CreateEntityRequest]::new();
        $request.Entity = $entityMetadata;
        $request.PrimaryAttribute = $primaryAttribute;
        $request.HasNotes = $HasNotes;
        $request.HasActivities = $HasActivities;

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

Export-ModuleMember -Function Add-XrmTable -Alias *;

Register-ArgumentCompleter -CommandName Add-XrmTable -ParameterName "LogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

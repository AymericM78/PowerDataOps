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

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityMetadata.

    .EXAMPLE
    $metadata = New-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects";
    Add-XrmTable -EntityMetadata $metadata -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";

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
        $IconVectorName
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

        $entityMetadata;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmTable -Alias *;

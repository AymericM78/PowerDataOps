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

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.EntityMetadata.

    .EXAMPLE
    $metadata = New-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects";
    Add-XrmTable -EntityMetadata $metadata -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";
#>
function New-XrmTable {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.EntityMetadata])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $true)]
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
        $LanguageCode = 1033
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $entityMetadata = [Microsoft.Xrm.Sdk.Metadata.EntityMetadata]::new();
        $entityMetadata.LogicalName = $LogicalName;
        $entityMetadata.SchemaName = $LogicalName;
        $entityMetadata.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $entityMetadata.DisplayCollectionName = New-XrmLabel -Text $PluralName -LanguageCode $LanguageCode;
        $entityMetadata.OwnershipType = $OwnershipType;
        $entityMetadata.IsActivity = $IsActivity;
        $entityMetadata.HasNotes = $HasNotes;
        $entityMetadata.HasActivities = $HasActivities;
        $entityMetadata.IsAuditEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($IsAuditEnabled);

        if (-not [string]::IsNullOrWhiteSpace($Description)) {
            $entityMetadata.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
        }

        $entityMetadata;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmTable -Alias *;

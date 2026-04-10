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

    .PARAMETER PrimaryAttributeSchemaName
    Schema name for the primary attribute.

    .PARAMETER PrimaryAttributeDisplayName
    Display name for the primary attribute.

    .PARAMETER PrimaryAttributeMaxLength
    Max length of the primary attribute. Default: 100.

    .PARAMETER SolutionUniqueName
    Solution unique name to add the table to.

    .PARAMETER LanguageCode
    Language code for labels. Default: 1033.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The CreateEntity response.

    .EXAMPLE
    $response = New-XrmTable -LogicalName "new_project" -DisplayName "Project" -PluralName "Projects" -PrimaryAttributeSchemaName "new_name" -PrimaryAttributeDisplayName "Name";
#>
function New-XrmTable {
    [CmdletBinding()]
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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrimaryAttributeSchemaName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrimaryAttributeDisplayName,

        [Parameter(Mandatory = $false)]
        [int]
        $PrimaryAttributeMaxLength = 100,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

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
        $entityMetadata.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $entityMetadata.DisplayCollectionName = New-XrmLabel -Text $PluralName -LanguageCode $LanguageCode;
        $entityMetadata.OwnershipType = $OwnershipType;
        $entityMetadata.IsActivity = $IsActivity;
        $entityMetadata.HasNotes = $HasNotes;
        $entityMetadata.HasActivities = $HasActivities;

        if (-not [string]::IsNullOrWhiteSpace($Description)) {
            $entityMetadata.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
        }

        $primaryAttribute = [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]::new();
        $primaryAttribute.SchemaName = $PrimaryAttributeSchemaName;
        $primaryAttribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new([Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::ApplicationRequired);
        $primaryAttribute.MaxLength = $PrimaryAttributeMaxLength;
        $primaryAttribute.DisplayName = New-XrmLabel -Text $PrimaryAttributeDisplayName -LanguageCode $LanguageCode;

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

Export-ModuleMember -Function New-XrmTable -Alias *;

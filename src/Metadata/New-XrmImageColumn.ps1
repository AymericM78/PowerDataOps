<#
    .SYNOPSIS
    Build an ImageAttributeMetadata for a Dataverse column.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata object
    that can be passed to Add-XrmColumn.

    .PARAMETER LogicalName
    Column logical name.

    .PARAMETER SchemaName
    Column schema name.

    .PARAMETER DisplayName
    Column display name.

    .PARAMETER MaxSizeInKb
    Max image size in kilobytes.

    .PARAMETER CanStoreFullImage
    Indicates whether the full image should be stored.

    .PARAMETER IsPrimaryImage
    Indicates whether the column is the primary image.

    .PARAMETER Description
    Column description label.

    .PARAMETER RequiredLevel
    Required level. Default: None.

    .PARAMETER LanguageCode
    Label language code. Default: 1033.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata.

    .EXAMPLE
    $attribute = New-XrmImageColumn -LogicalName "new_profileimage" -SchemaName "new_ProfileImage" -DisplayName "Profile Image" -MaxSizeInKb 10240 -CanStoreFullImage;
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/image-column-data
#>
function New-XrmImageColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SchemaName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [int]
        $MaxSizeInKb = 10240,

        [Parameter(Mandatory = $false)]
        [switch]
        $CanStoreFullImage,

        [Parameter(Mandatory = $false)]
        [switch]
        $IsPrimaryImage,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]
        $RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attribute = [Microsoft.Xrm.Sdk.Metadata.ImageAttributeMetadata]::new();
        $attribute.LogicalName = $LogicalName;
        $attribute.SchemaName = $SchemaName;
        $attribute.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $attribute.MaxSizeInKB = $MaxSizeInKb;
        $attribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new($RequiredLevel);

        if ($PSBoundParameters.ContainsKey('CanStoreFullImage')) {
            $attribute.CanStoreFullImage = $CanStoreFullImage.IsPresent;
        }

        if ($PSBoundParameters.ContainsKey('IsPrimaryImage')) {
            $attribute.IsPrimaryImage = $IsPrimaryImage.IsPresent;
        }

        if (-not [string]::IsNullOrWhiteSpace($Description)) {
            $attribute.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
        }

        $attribute;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Set-Alias -Name New-ImageColumn -Value New-XrmImageColumn;
Export-ModuleMember -Function New-XrmImageColumn -Alias *;
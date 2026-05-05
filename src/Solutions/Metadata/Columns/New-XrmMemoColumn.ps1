<#
    .SYNOPSIS
    Build a MemoAttributeMetadata for a Dataverse column.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata object
    that can be passed to Add-XrmColumn.

    .PARAMETER LogicalName
    Column logical name.

    .PARAMETER SchemaName
    Column schema name.

    .PARAMETER DisplayName
    Column display name.

    .PARAMETER MaxLength
    Maximum text length.

    .PARAMETER Description
    Column description label.

    .PARAMETER RequiredLevel
    Required level. Default: None.

    .PARAMETER LanguageCode
    Label language code. Default: 1033.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata.

    .EXAMPLE
    $attribute = New-XrmMemoColumn -LogicalName "new_notes" -SchemaName "new_Notes" -DisplayName "Notes" -MaxLength 4000;
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns
#>
function New-XrmMemoColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata])]
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

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 1048576)]
        [int]
        $MaxLength,

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
        $attribute = [Microsoft.Xrm.Sdk.Metadata.MemoAttributeMetadata]::new();
        $attribute.LogicalName = $LogicalName;
        $attribute.SchemaName = $SchemaName;
        $attribute.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $attribute.MaxLength = $MaxLength;
        $attribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new($RequiredLevel);

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

Set-Alias -Name New-MemoColumn -Value New-XrmMemoColumn;
Export-ModuleMember -Function New-XrmMemoColumn -Alias *;

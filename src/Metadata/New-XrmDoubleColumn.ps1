<#
    .SYNOPSIS
    Build a DoubleAttributeMetadata for a Dataverse column.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.DoubleAttributeMetadata object
    that can be passed to New-XrmColumn.

    .PARAMETER LogicalName
    Column logical name.

    .PARAMETER SchemaName
    Column schema name.

    .PARAMETER DisplayName
    Column display name.

    .PARAMETER Precision
    Decimal precision.

    .PARAMETER MinValue
    Minimum accepted value.

    .PARAMETER MaxValue
    Maximum accepted value.

    .PARAMETER Description
    Column description label.

    .PARAMETER RequiredLevel
    Required level. Default: None.

    .PARAMETER LanguageCode
    Label language code. Default: 1033.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.DoubleAttributeMetadata.

    .EXAMPLE
    $attribute = New-XrmDoubleColumn -LogicalName "new_ratio" -SchemaName "new_Ratio" -DisplayName "Ratio" -Precision 2 -MinValue 0 -MaxValue 100;
    New-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns
#>
function New-XrmDoubleColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.DoubleAttributeMetadata])]
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
        $Precision = 2,

        [Parameter(Mandatory = $false)]
        [double]
        $MinValue = 0,

        [Parameter(Mandatory = $false)]
        [double]
        $MaxValue = 1000000000,

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
        $attribute = [Microsoft.Xrm.Sdk.Metadata.DoubleAttributeMetadata]::new();
        $attribute.LogicalName = $LogicalName;
        $attribute.SchemaName = $SchemaName;
        $attribute.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $attribute.Precision = $Precision;
        $attribute.MinValue = $MinValue;
        $attribute.MaxValue = $MaxValue;
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

Set-Alias -Name New-DoubleColumn -Value New-XrmDoubleColumn;
Export-ModuleMember -Function New-XrmDoubleColumn -Alias *;
<#
    .SYNOPSIS
    Build a BooleanAttributeMetadata for a Dataverse column.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata object
    that can be passed to Add-XrmColumn.

    .PARAMETER LogicalName
    Column logical name.

    .PARAMETER SchemaName
    Column schema name.

    .PARAMETER DisplayName
    Column display name.

    .PARAMETER DefaultValue
    Default boolean value.

    .PARAMETER TrueLabel
    Label used for the true option. Default: Yes.

    .PARAMETER FalseLabel
    Label used for the false option. Default: No.

    .PARAMETER Description
    Column description label.

    .PARAMETER RequiredLevel
    Required level. Default: None.

    .PARAMETER EnableForInteractiveExperience
    Enables the column for interactive dashboards (sets IsGlobalFilterEnabled and IsSortableEnabled).

    .PARAMETER LanguageCode
    Label language code. Default: 1033.

    .PARAMETER TrueLabels
    Label of the true option by language code (e.g. @{ 1033 = "Active"; 1036 = "Actif" }), instead of TrueLabel.

    .PARAMETER FalseLabels
    Label of the false option by language code, instead of FalseLabel.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata.

    .EXAMPLE
    $attribute = New-XrmBooleanColumn -LogicalName "new_enabled" -SchemaName "new_Enabled" -DisplayName "Enabled" -DefaultValue $false -TrueLabel "Active" -FalseLabel "Inactive";
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .EXAMPLE
    # Multilingual: the column labels go through Add-XrmColumn -DisplayNameLabels, the option labels through the constructor
    $attribute = New-XrmBooleanColumn -LogicalName "new_enabled" -SchemaName "new_Enabled" -DisplayName "Enabled" -TrueLabels @{ 1033 = "Active"; 1036 = "Actif" } -FalseLabels @{ 1033 = "Inactive"; 1036 = "Inactif" };
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute -DisplayNameLabels @{ 1033 = "Enabled"; 1036 = "Active" };

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns
#>
function New-XrmBooleanColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata])]
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
        [bool]
        $DefaultValue = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TrueLabel = "Yes",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FalseLabel = "No",

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]
        $RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None,

        [Parameter(Mandatory = $false)]
        [switch]
        $EnableForInteractiveExperience,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $TrueLabels,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $FalseLabels
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attribute = [Microsoft.Xrm.Sdk.Metadata.BooleanAttributeMetadata]::new();
        $attribute.LogicalName = $LogicalName;
        $attribute.SchemaName = $SchemaName;
        $attribute.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $attribute.DefaultValue = $DefaultValue;
        $attribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new($RequiredLevel);

        $trueOption = [Microsoft.Xrm.Sdk.Metadata.OptionMetadata]::new();
        $trueOption.Label = $(if ($PSBoundParameters.ContainsKey('TrueLabels')) { New-XrmLabel -Labels $TrueLabels } else { New-XrmLabel -Text $TrueLabel -LanguageCode $LanguageCode });
        $trueOption.Value = 1;

        $falseOption = [Microsoft.Xrm.Sdk.Metadata.OptionMetadata]::new();
        $falseOption.Label = $(if ($PSBoundParameters.ContainsKey('FalseLabels')) { New-XrmLabel -Labels $FalseLabels } else { New-XrmLabel -Text $FalseLabel -LanguageCode $LanguageCode });
        $falseOption.Value = 0;

        $optionSet = [Microsoft.Xrm.Sdk.Metadata.BooleanOptionSetMetadata]::new();
        $optionSet.TrueOption = $trueOption;
        $optionSet.FalseOption = $falseOption;
        $attribute.OptionSet = $optionSet;

        if (-not [string]::IsNullOrWhiteSpace($Description)) {
            $attribute.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
        }

        if ($EnableForInteractiveExperience.IsPresent) {
            $attribute.IsGlobalFilterEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($true);
            $attribute.IsSortableEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($true);
        }

        $attribute;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Set-Alias -Name New-BooleanColumn -Value New-XrmBooleanColumn;
Export-ModuleMember -Function New-XrmBooleanColumn -Alias *;

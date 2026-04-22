<#
    .SYNOPSIS
    Build a MultiSelectPicklistAttributeMetadata for a Dataverse column.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata object
    referencing a global option set or defining local options, ready for Add-XrmColumn.

    .PARAMETER LogicalName
    Column logical name.

    .PARAMETER SchemaName
    Column schema name.

    .PARAMETER DisplayName
    Column display name.

    .PARAMETER GlobalOptionSetName
    Global option set name.

    .PARAMETER LocalOptions
    Local option labels to embed directly in the column metadata.

    .PARAMETER Options
    Local option metadata objects to embed directly in the column metadata.

    .PARAMETER StartingValue
    Starting integer value for local options. Default: 100000000.

    .PARAMETER Description
    Column description label.

    .PARAMETER RequiredLevel
    Required level. Default: None.

    .PARAMETER LanguageCode
    Label language code. Default: 1033.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata.

    .EXAMPLE
    $attribute = New-XrmMultiChoiceColumn -LogicalName "new_tags" -SchemaName "new_Tags" -DisplayName "Tags" -GlobalOptionSetName "new_tagchoices";
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .EXAMPLE
    $attribute = New-XrmMultiChoiceColumn -LogicalName "new_preferences" -SchemaName "new_Preferences" -DisplayName "Preferences" -LocalOptions @("Phone", "Email", "SMS");
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .EXAMPLE
    $options = @(
        (New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Phone") -Color "#CDDAFD"),
        (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "Email") -Color "#FCE1E4")
    );
    $attribute = New-XrmMultiChoiceColumn -LogicalName "new_preferences" -SchemaName "new_Preferences" -DisplayName "Preferences" -Options $options;
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/multi-select-picklist
#>
function New-XrmMultiChoiceColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata])]
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

        [Parameter(Mandatory = $true, ParameterSetName = 'ByGlobalOptionSet')]
        [ValidateNotNullOrEmpty()]
        [string]
        $GlobalOptionSetName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByLocalOptions')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $LocalOptions,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByOptionMetadata')]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OptionMetadata[]]
        $Options,

        [Parameter(Mandatory = $false, ParameterSetName = 'ByLocalOptions')]
        [int]
        $StartingValue = 100000000,

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
        $attribute = [Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata]::new();
        $attribute.LogicalName = $LogicalName;
        $attribute.SchemaName = $SchemaName;
        $attribute.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $attribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new($RequiredLevel);

        $optionSet = [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata]::new();
        if ($PSCmdlet.ParameterSetName -eq 'ByGlobalOptionSet') {
            $optionSet.IsGlobal = $true;
            $optionSet.Name = $GlobalOptionSetName;
        }
        else {
            $optionSet.IsGlobal = $false;
            $optionSet.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;
            $optionSet.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;

            if (-not [string]::IsNullOrWhiteSpace($Description)) {
                $optionSet.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
            }

            if ($PSCmdlet.ParameterSetName -eq 'ByLocalOptions') {
                $currentValue = $StartingValue;
                foreach ($localOption in $LocalOptions) {
                    $option = [Microsoft.Xrm.Sdk.Metadata.OptionMetadata]::new();
                    $option.Label = New-XrmLabel -Text $localOption -LanguageCode $LanguageCode;
                    $option.Value = $currentValue;
                    $optionSet.Options.Add($option);
                    $currentValue++;
                }
            }
            else {
                foreach ($option in $Options) {
                    $optionSet.Options.Add($option);
                }
            }
        }
        $attribute.OptionSet = $optionSet;

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

Set-Alias -Name New-MultiChoiceColumn -Value New-XrmMultiChoiceColumn;
Export-ModuleMember -Function New-XrmMultiChoiceColumn -Alias *;
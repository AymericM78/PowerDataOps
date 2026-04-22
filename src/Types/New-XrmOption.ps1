<#
    .SYNOPSIS
    Build an OptionMetadata object for Dataverse option sets.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.OptionMetadata object that can be reused
    when creating global option sets, local choice columns, or synchronizing option values.

    .PARAMETER Value
    Integer value of the option.

    .PARAMETER Label
    Display label for the option.

    .PARAMETER Description
    Optional description label.

    .PARAMETER Color
    Optional hexadecimal color (for example #5B8DEF).

    .PARAMETER IsManaged
    Optional managed state.

    .PARAMETER ExternalValue
    Optional external value.

    .PARAMETER ParentValues
    Optional parent values for hierarchical choices.

    .PARAMETER Tag
    Optional tag value.

    Dataverse exposes `IsHidden` with a non-public setter on OptionMetadata, so it is not configurable through this helper.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.OptionMetadata.

    .EXAMPLE
    $option = New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD";
#>
function New-XrmOption {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.OptionMetadata])]
    param
    (
        [Parameter(Mandatory = $true)]
        [int]
        $Value,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Label]
        $Label,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Label]
        $Description,

        [Parameter(Mandatory = $false)]
        [ValidatePattern('^#[0-9A-Fa-f]{6}$')]
        [string]
        $Color,

        [Parameter(Mandatory = $false)]
        [Nullable[bool]]
        $IsManaged,

        [Parameter(Mandatory = $false)]
        [string]
        $ExternalValue,

        [Parameter(Mandatory = $false)]
        [int[]]
        $ParentValues,

        [Parameter(Mandatory = $false)]
        [string]
        $Tag
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $option = [Microsoft.Xrm.Sdk.Metadata.OptionMetadata]::new();
        $option.Value = $Value;
        $option.Label = $Label;

        if ($PSBoundParameters.ContainsKey('Description')) {
            $option.Description = $Description;
        }
        if ($PSBoundParameters.ContainsKey('Color')) {
            $option.Color = $Color;
        }
        if ($PSBoundParameters.ContainsKey('IsManaged')) {
            $option.IsManaged = $IsManaged;
        }
        if ($PSBoundParameters.ContainsKey('ExternalValue')) {
            $option.ExternalValue = $ExternalValue;
        }
        if ($PSBoundParameters.ContainsKey('ParentValues')) {
            $option.ParentValues = $ParentValues;
        }
        if ($PSBoundParameters.ContainsKey('Tag')) {
            $option.Tag = $Tag;
        }

        $option;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmOption -Alias *;
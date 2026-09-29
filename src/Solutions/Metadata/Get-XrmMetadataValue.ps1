<#
    .SYNOPSIS
    Read a value from a metadata object.

    .DESCRIPTION
    Read a property of a metadata object (EntityMetadata, AttributeMetadata, RelationshipMetadata, OptionSetMetadata...) as a plain value.
    A managed property (BooleanManagedProperty, AttributeRequiredLevelManagedProperty...) gives its Value, or its CanBeChanged flag with CanBeChanged.
    A Label gives the text for LanguageCode, or the user label when LanguageCode is not given.
    Property accepts a dotted path (e.g. "OptionSet.Name"). A missing intermediate value gives $null.

    .PARAMETER Metadata
    Metadata object to read.

    .PARAMETER Property
    Property name, or dotted path of property names.

    .PARAMETER CanBeChanged
    Return the CanBeChanged flag of a managed property instead of its value.

    .PARAMETER LanguageCode
    Language of the text to return when the property is a Label. (Default: user localized label)

    .OUTPUTS
    System.Object. The plain value.

    .EXAMPLE
    $entityMetadata = Get-XrmEntityMetadata -LogicalName "account";
    $isAuditEnabled = Get-XrmMetadataValue -Metadata $entityMetadata -Property "IsAuditEnabled";
    $canChangeAudit = Get-XrmMetadataValue -Metadata $entityMetadata -Property "IsAuditEnabled" -CanBeChanged;

    .EXAMPLE
    $frenchName = $entityMetadata | Get-XrmMetadataValue -Property "DisplayName" -LanguageCode 1036;

    .EXAMPLE
    $requiredLevel = $attributeMetadata | Get-XrmMetadataValue -Property "RequiredLevel";   # AttributeRequiredLevel enum value

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmMetadataValue.md
#>
function Get-XrmMetadataValue {
    [CmdletBinding()]
    [OutputType([System.Object])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNull()]
        [Object]
        $Metadata,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Property,

        [Parameter(Mandatory = $false)]
        [switch]
        $CanBeChanged,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $value = $Metadata;
        foreach ($segment in $Property.Split('.')) {
            if ($null -eq $value) {
                break;
            }
            $propertyInfo = $value.PSObject.Properties[$segment];
            if (-not $propertyInfo) {
                throw "Property '$segment' not found on $($value.GetType().Name).";
            }
            $value = $propertyInfo.Value;
        }

        $isManagedProperty = $null -ne $value -and $value.PSObject.Properties["CanBeChanged"] -and $value.PSObject.Properties["ManagedPropertyLogicalName"];
        if ($CanBeChanged) {
            if (-not $isManagedProperty) {
                throw "Property '$Property' is not a managed property: it has no CanBeChanged flag.";
            }
            return [bool]$value.CanBeChanged;
        }
        if ($null -eq $value) {
            return $null;
        }
        if ($isManagedProperty) {
            return $value.Value;
        }
        if ($value -is [Microsoft.Xrm.Sdk.Label]) {
            if ($PSBoundParameters.ContainsKey('LanguageCode')) {
                $localizedLabel = $value.LocalizedLabels | Where-Object { $_.LanguageCode -eq $LanguageCode } | Select-Object -First 1;
                return $(if ($localizedLabel) { $localizedLabel.Label } else { $null });
            }
            if ($value.UserLocalizedLabel) {
                return $value.UserLocalizedLabel.Label;
            }
            $firstLabel = $value.LocalizedLabels | Select-Object -First 1;
            return $(if ($firstLabel) { $firstLabel.Label } else { $null });
        }
        return $value;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmMetadataValue -Alias *;

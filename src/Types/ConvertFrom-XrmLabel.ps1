<#
    .SYNOPSIS
    Convert a Label to a hashtable of texts by language code.

    .DESCRIPTION
    Turn a Microsoft.Xrm.Sdk.Label (metadata display names, descriptions, option labels...) into @{ languageCode = text }: the reverse of New-XrmLabel -Labels.
    A $null label gives an empty hashtable.

    .PARAMETER Label
    Label to convert.

    .PARAMETER LanguageCodes
    Language codes to keep. (Default: every language of the label)

    .OUTPUTS
    System.Collections.Hashtable. Text by language code (int keys).

    .EXAMPLE
    $table = Get-XrmEntityMetadata -XrmClient $xrmClient -LogicalName "account" -Filter Entity;
    $names = ConvertFrom-XrmLabel -Label $table.DisplayName;   # @{ 1033 = "Account"; 1036 = "Compte" }

    .EXAMPLE
    # Copy the display names of one column to another
    $labels = ConvertFrom-XrmLabel -Label $sourceColumn.DisplayName -LanguageCodes 1033, 1036;
    Set-XrmColumn -XrmClient $xrmClient -EntityLogicalName "account" -Attribute $targetColumn -DisplayNameLabels $labels;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/ConvertFrom-XrmLabel.md
#>
function ConvertFrom-XrmLabel {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [AllowNull()]
        [Microsoft.Xrm.Sdk.Label]
        $Label,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $LanguageCodes
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $labels = @{};
        if ($null -ne $Label) {
            foreach ($localizedLabel in $Label.LocalizedLabels) {
                if ($PSBoundParameters.ContainsKey('LanguageCodes') -and $LanguageCodes -notcontains $localizedLabel.LanguageCode) {
                    continue;
                }
                $labels[[int]$localizedLabel.LanguageCode] = $localizedLabel.Label;
            }
        }
        $labels;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function ConvertFrom-XrmLabel -Alias *;

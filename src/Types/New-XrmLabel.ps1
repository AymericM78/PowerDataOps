<#
    .SYNOPSIS
    Create a Label object for Dataverse metadata.

    .DESCRIPTION
    Build a Microsoft.Xrm.Sdk.Label from a single text value and language code, or from a
    hashtable of language code to text for multilingual labels.

    .PARAMETER Text
    The label text (single language).

    .PARAMETER LanguageCode
    Language code for the label. Default: 1033 (English).

    .PARAMETER Labels
    Hashtable of language code to label text for multilingual labels. Example: @{ 1033 = "Account"; 1036 = "Compte" }

    .OUTPUTS
    Microsoft.Xrm.Sdk.Label. The label object.

    .EXAMPLE
    $label = New-XrmLabel -Text "Account" -LanguageCode 1033;

    .EXAMPLE
    $label = New-XrmLabel -Labels @{ 1033 = "Account"; 1036 = "Compte" };
#>
function New-XrmLabel {
    [CmdletBinding(DefaultParameterSetName = "Single")]
    [OutputType([Microsoft.Xrm.Sdk.Label])]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = "Single")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Text,

        [Parameter(Mandatory = $false, ParameterSetName = "Single")]
        [int]
        $LanguageCode = 1033,

        [Parameter(Mandatory = $true, ParameterSetName = "Multi")]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "Multi") {
            $label = [Microsoft.Xrm.Sdk.Label]::new();
            foreach ($langCode in $Labels.Keys) {
                $localizedLabel = [Microsoft.Xrm.Sdk.LocalizedLabel]::new($Labels[$langCode], [int]$langCode);
                $label.LocalizedLabels.Add($localizedLabel);
            }
            $label;
            return;
        }

        $label = [Microsoft.Xrm.Sdk.Label]::new($Text, $LanguageCode);
        $label;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmLabel -Alias *;

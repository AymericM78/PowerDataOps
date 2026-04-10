<#
    .SYNOPSIS
    Create a Label object for Dataverse metadata.

    .DESCRIPTION
    Build a Microsoft.Xrm.Sdk.Label from a text value and language code.

    .PARAMETER Text
    The label text.

    .PARAMETER LanguageCode
    Language code for the label. Default: 1033 (English).

    .OUTPUTS
    Microsoft.Xrm.Sdk.Label. The label object.

    .EXAMPLE
    $label = New-XrmLabel -Text "Account" -LanguageCode 1033;
#>
function New-XrmLabel {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Label])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Text,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $label = [Microsoft.Xrm.Sdk.Label]::new($Text, $LanguageCode);
        $label;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function New-XrmLabel -Alias *;

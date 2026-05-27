<#
    .SYNOPSIS
    Resolve a single label text from a multilingual labels hashtable.

    .DESCRIPTION
    Pick the label text for a given language code from a hashtable of language code to text.
    If the requested language is not present, falls back to the lowest language code available.
    Used by component cmdlets (forms, views, charts, dashboards, commands, app modules, sitemaps)
    that store a single 'name' attribute but accept a multilingual -Labels hashtable for a
    consistent authoring experience.

    .PARAMETER Labels
    Hashtable of language code to label text. Example: @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" }

    .PARAMETER LanguageCode
    Preferred language code to resolve. Default: 1033 (English).

    .OUTPUTS
    [String]. The resolved label text.

    .EXAMPLE
    $name = Get-XrmLabelText -Labels @{ 1033 = "Active accounts"; 1036 = "Comptes actifs" } -LanguageCode 1036;
    # returns "Comptes actifs"

    .EXAMPLE
    $name = Get-XrmLabelText -Labels @{ 1036 = "Comptes actifs" } -LanguageCode 1033;
    # 1033 missing -> falls back to "Comptes actifs"
#>
function Get-XrmLabelText {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Labels,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if ($Labels.ContainsKey($LanguageCode)) {
            return [string]$Labels[$LanguageCode];
        }
        if ($Labels.ContainsKey([string]$LanguageCode)) {
            return [string]$Labels[[string]$LanguageCode];
        }
        $fallbackKey = $Labels.Keys | Sort-Object | Select-Object -First 1;
        return [string]$Labels[$fallbackKey];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmLabelText -Alias *;

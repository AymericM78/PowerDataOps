<#
    Build a unique name that only holds ASCII letters and digits from a display name, e.g. for sitemapnameunique.
    Accents are removed (é => e), any other character is dropped, and the result is cut to MaxLength.
    Raises an error when nothing is left, so the caller asks for an explicit unique name.
#>
function ConvertTo-XrmUniqueNameInternal {
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [int]
        $MaxLength = 40
    )

    $decomposed = $Name.Normalize([System.Text.NormalizationForm]::FormD);
    $builder = [System.Text.StringBuilder]::new();
    foreach ($character in $decomposed.ToCharArray()) {
        if ([System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($character) -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$builder.Append($character);
        }
    }
    $uniqueName = $builder.ToString() -replace '[^a-zA-Z0-9]', '';
    if ($uniqueName.Length -gt $MaxLength) {
        $uniqueName = $uniqueName.Substring(0, $MaxLength);
    }
    if ([string]::IsNullOrEmpty($uniqueName)) {
        throw "Cannot build a unique name from '$Name': it holds no letter or digit. Pass an explicit unique name.";
    }
    $uniqueName;
}

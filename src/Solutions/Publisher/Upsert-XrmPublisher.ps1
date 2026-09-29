<#
    .SYNOPSIS
    Create or update a publisher.

    .DESCRIPTION
    Find the publisher by unique name; create it when missing, else update the given properties.
    Creation requires a display name (DisplayName or DisplayNameLabels), Prefix and OptionValuePrefix.
    With DisplayNameLabels, the display name is also set in each language (SetLocLabels); without DisplayName, the text of the base language (or the lowest language code) is used.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UniqueName
    Publisher unique name.

    .PARAMETER DisplayName
    Publisher display name.

    .PARAMETER DisplayNameLabels
    Display name by language code (e.g. @{ 1033 = "Contoso"; 1036 = "Contoso FR" }).

    .PARAMETER Prefix
    Customization prefix (2 to 8 lowercase letters).

    .PARAMETER OptionValuePrefix
    Option value prefix (10000 to 99999).

    .PARAMETER Description
    Publisher description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the publisher.

    .EXAMPLE
    $publisher = Upsert-XrmPublisher -XrmClient $xrmClient -UniqueName "contoso" -DisplayNameLabels @{ 1033 = "Contoso"; 1036 = "Contoso" } -Prefix "cts" -OptionValuePrefix 12345;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmPublisher.md
#>
function Upsert-XrmPublisher {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.EntityReference])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $DisplayNameLabels,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[a-z]{2,8}$")]
        [String]
        $Prefix,

        [Parameter(Mandatory = $false)]
        [ValidateRange(10000, 99999)]
        [int]
        $OptionValuePrefix,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $Description
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $displayNameValue = $DisplayName;
        if (-not $displayNameValue -and $PSBoundParameters.ContainsKey('DisplayNameLabels')) {
            $baseLanguage = @(Get-XrmProvisionedLanguages -XrmClient $XrmClient -BaseFirst)[0];
            $displayNameValue = Get-XrmLabelText -Labels $DisplayNameLabels -LanguageCode $baseLanguage;
        }

        $existing = Get-XrmPublisher -XrmClient $XrmClient -PublisherUniqueName $UniqueName -Columns "publisherid";
        if ($existing) {
            $publisherReference = $existing.Reference;
            $attributes = @{};
            if ($displayNameValue) { $attributes["friendlyname"] = $displayNameValue; }
            if ($PSBoundParameters.ContainsKey('Prefix')) { $attributes["customizationprefix"] = $Prefix; }
            if ($PSBoundParameters.ContainsKey('OptionValuePrefix')) { $attributes["customizationoptionvalueprefix"] = $OptionValuePrefix; }
            if ($PSBoundParameters.ContainsKey('Description')) { $attributes["description"] = $Description; }
            if ($attributes.Count -gt 0) {
                $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "publisher" -Id $publisherReference.Id -Attributes $attributes) -ErrorAction Stop;
            }
        }
        else {
            if (-not $displayNameValue -or -not $PSBoundParameters.ContainsKey('Prefix') -or -not $PSBoundParameters.ContainsKey('OptionValuePrefix')) {
                throw "Publisher '$UniqueName' does not exist: DisplayName (or DisplayNameLabels), Prefix and OptionValuePrefix are required to create it.";
            }
            $addParameters = @{
                XrmClient         = $XrmClient;
                UniqueName        = $UniqueName;
                DisplayName       = $displayNameValue;
                Prefix            = $Prefix;
                OptionValuePrefix = $OptionValuePrefix;
            };
            if ($PSBoundParameters.ContainsKey('Description')) { $addParameters["Description"] = $Description; }
            $publisherReference = Add-XrmPublisher @addParameters -ErrorAction Stop;
            if (-not $publisherReference) {
                # Skipped by -WhatIf
                return;
            }
        }

        if ($PSBoundParameters.ContainsKey('DisplayNameLabels')) {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $publisherReference -AttributeName "friendlyname" -Labels $DisplayNameLabels | Out-Null;
        }
        $publisherReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmPublisher -Alias *;

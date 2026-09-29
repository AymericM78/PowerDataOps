<#
    .SYNOPSIS
    Create or update an unmanaged solution.

    .DESCRIPTION
    Find the solution by unique name; create it when missing, else update the given properties.
    Creation requires a display name (DisplayName or DisplayNameLabels) and a publisher (PublisherUniqueName or PublisherReference).
    With DisplayNameLabels, the display name is also set in each language (SetLocLabels); without DisplayName, the text of the base language (or the lowest language code) is used.
    Raises an error when the solution is managed.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER UniqueName
    Solution unique name.

    .PARAMETER DisplayName
    Solution display name.

    .PARAMETER DisplayNameLabels
    Display name by language code (e.g. @{ 1033 = "Core"; 1036 = "Socle" }).

    .PARAMETER PublisherUniqueName
    Publisher unique name.

    .PARAMETER PublisherReference
    Publisher reference, instead of PublisherUniqueName.

    .PARAMETER Version
    Solution version. (Default at creation: 1.0.0.0)

    .PARAMETER Description
    Solution description.

    .OUTPUTS
    Microsoft.Xrm.Sdk.EntityReference. Reference of the solution.

    .EXAMPLE
    $solution = Upsert-XrmSolution -XrmClient $xrmClient -UniqueName "ContosoCore" -DisplayNameLabels @{ 1033 = "Contoso core"; 1036 = "Socle Contoso" } -PublisherUniqueName "contoso" -Version "1.2.0.0";

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmSolution.md
#>
function Upsert-XrmSolution {
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
        [ValidateNotNullOrEmpty()]
        [String]
        $PublisherUniqueName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $PublisherReference,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^\d+(\.\d+){1,3}$")]
        [String]
        $Version,

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

        $publisher = $PublisherReference;
        if ($PSBoundParameters.ContainsKey('PublisherUniqueName')) {
            $publisherRow = Get-XrmPublisher -XrmClient $XrmClient -PublisherUniqueName $PublisherUniqueName -Columns "publisherid";
            if (-not $publisherRow) {
                throw "Publisher '$PublisherUniqueName' not found.";
            }
            $publisher = $publisherRow.Reference;
        }

        $existing = Get-XrmSolution -XrmClient $XrmClient -SolutionUniqueName $UniqueName -Columns "solutionid", "ismanaged";
        if ($existing) {
            if ($existing | Get-XrmAttributeValue -Name "ismanaged") {
                throw "Solution '$UniqueName' is managed: it cannot be updated.";
            }
            $solutionReference = $existing.Reference;
            $attributes = @{};
            if ($displayNameValue) { $attributes["friendlyname"] = $displayNameValue; }
            if ($publisher) { $attributes["publisherid"] = $publisher; }
            if ($PSBoundParameters.ContainsKey('Version')) { $attributes["version"] = $Version; }
            if ($PSBoundParameters.ContainsKey('Description')) { $attributes["description"] = $Description; }
            if ($attributes.Count -gt 0) {
                $XrmClient | Update-XrmRecord -Record (New-XrmEntity -LogicalName "solution" -Id $solutionReference.Id -Attributes $attributes) -ErrorAction Stop;
            }
        }
        else {
            if (-not $displayNameValue -or -not $publisher) {
                throw "Solution '$UniqueName' does not exist: DisplayName (or DisplayNameLabels) and PublisherUniqueName (or PublisherReference) are required to create it.";
            }
            $addParameters = @{
                XrmClient          = $XrmClient;
                UniqueName         = $UniqueName;
                DisplayName        = $displayNameValue;
                PublisherReference = $publisher;
            };
            if ($PSBoundParameters.ContainsKey('Version')) { $addParameters["Version"] = $Version; }
            if ($PSBoundParameters.ContainsKey('Description')) { $addParameters["Description"] = $Description; }
            $solutionReference = Add-XrmSolution @addParameters -ErrorAction Stop;
            if (-not $solutionReference) {
                # Skipped by -WhatIf
                return;
            }
        }

        if ($PSBoundParameters.ContainsKey('DisplayNameLabels')) {
            Set-XrmLocalizedLabel -XrmClient $XrmClient -EntityMoniker $solutionReference -AttributeName "friendlyname" -Labels $DisplayNameLabels | Out-Null;
        }
        $solutionReference;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Upsert-XrmSolution -Alias *;

<#
    .SYNOPSIS
    Retrieve the labels of a localizable column of a row, in every language.

    .DESCRIPTION
    Read the translations of a localizable text column of a row (RetrieveLocLabels): e.g. the name of a view, a form, an app, a solution or a publisher.
    Reading counterpart of Set-XrmLocalizedLabel. Returns the Label (one LocalizedLabel per language), or a hashtable @{ languageCode = text } with AsHashtable, ready for Set-XrmLocalizedLabel -Labels.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityMoniker
    Reference of the row.

    .PARAMETER AttributeName
    Localizable column logical name (e.g. "name", "friendlyname").

    .PARAMETER IncludeUnpublished
    Read the unpublished labels. (Default: true)

    .PARAMETER AsHashtable
    Return @{ languageCode = text } instead of the Label.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Label, or Hashtable with AsHashtable.

    .EXAMPLE
    $labels = Get-XrmLocalizedLabel -XrmClient $xrmClient -EntityMoniker $view.Reference -AttributeName "name" -AsHashtable;
    $labels[1036];

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmLocalizedLabel.md
#>
function Get-XrmLocalizedLabel {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Label], [Hashtable])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.EntityReference]
        $EntityMoniker,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AttributeName,

        [Parameter(Mandatory = $false)]
        [bool]
        $IncludeUnpublished = $true,

        [Parameter(Mandatory = $false)]
        [switch]
        $AsHashtable
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "RetrieveLocLabels";
        $request = $request | Add-XrmRequestParameter -Name "EntityMoniker" -Value $EntityMoniker;
        $request = $request | Add-XrmRequestParameter -Name "AttributeName" -Value $AttributeName;
        $request = $request | Add-XrmRequestParameter -Name "IncludeUnpublished" -Value $IncludeUnpublished;
        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        if ($null -eq $response) {
            return;
        }
        $label = $response.Results["Label"];
        if (-not $AsHashtable) {
            return $label;
        }
        ConvertFrom-XrmLabel -Label $label;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmLocalizedLabel -Alias *;

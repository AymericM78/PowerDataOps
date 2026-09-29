<#
    .SYNOPSIS
    Retrieve the languages provisioned in the organization.

    .DESCRIPTION
    Get the language codes (LCID) enabled in the organization (RetrieveProvisionedLanguages), in ascending order, or with the base language first.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER BaseFirst
    Put the base language of the organization (organization.languagecode) first.

    .OUTPUTS
    System.Int32[]. Language codes.

    .EXAMPLE
    $languages = Get-XrmProvisionedLanguages -XrmClient $xrmClient -BaseFirst;
    $baseLanguage = $languages[0];

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmProvisionedLanguages.md
#>
function Get-XrmProvisionedLanguages {
    [CmdletBinding()]
    [OutputType([int[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [switch]
        $BaseFirst
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $response = $XrmClient | Invoke-XrmRequest -Request (New-XrmRequest -Name "RetrieveProvisionedLanguages");
        if ($null -eq $response) {
            return;
        }
        $languages = @($response.Results["RetrieveProvisionedLanguages"] | ForEach-Object { [int]$_ } | Sort-Object);
        if ($BaseFirst) {
            $query = New-XrmQueryExpression -LogicalName "organization" -Columns "languagecode" -TopCount 1;
            $organizations = $XrmClient | Get-XrmMultipleRecords -Query $query -AsEntity -AsArray;
            $baseLanguage = [int]$organizations[0]["languagecode"];
            $languages = @($baseLanguage) + @($languages | Where-Object { $_ -ne $baseLanguage });
        }
        $languages;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmProvisionedLanguages -Alias *;

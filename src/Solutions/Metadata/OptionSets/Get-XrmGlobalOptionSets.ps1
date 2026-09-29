<#
    .SYNOPSIS
    Retrieve every global option set (choice) definition.

    .DESCRIPTION
    Get the metadata of all global option sets (RetrieveAllOptionSets): OptionSetMetadata, or BooleanOptionSetMetadata for the global yes/no choices.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER RetrieveAsIfPublished
    Include the unpublished changes. (Default: true)

    .PARAMETER CustomOnly
    Keep the custom option sets (IsCustomOptionSet).

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase[].

    .EXAMPLE
    Get-XrmGlobalOptionSets -XrmClient $xrmClient -CustomOnly | Select-Object Name, @{ Name = "Options"; Expression = { $_.Options.Count } };

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmGlobalOptionSets.md
#>
function Get-XrmGlobalOptionSets {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase[]])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [bool]
        $RetrieveAsIfPublished = $true,

        [Parameter(Mandatory = $false)]
        [switch]
        $CustomOnly
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $request = New-XrmRequest -Name "RetrieveAllOptionSets";
        $request = $request | Add-XrmRequestParameter -Name "RetrieveAsIfPublished" -Value $RetrieveAsIfPublished;
        $response = $XrmClient | Invoke-XrmRequest -Request $request;
        if ($null -eq $response) {
            return;
        }
        $optionSets = $response.Results["OptionSetMetadata"];
        if ($CustomOnly) {
            $optionSets = $optionSets | Where-Object { $_.IsCustomOptionSet };
        }
        $optionSets;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Get-XrmGlobalOptionSets -Alias *;

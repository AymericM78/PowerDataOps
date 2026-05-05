<#
    .SYNOPSIS
    Synchronize the options of a global option set.

    .DESCRIPTION
    Update the list of options of an existing global option set from a typed OptionMetadata list.
    Existing values are updated with Set-XrmOptionSetValue, missing values are created with
    Add-XrmOptionSetValue, and extra values can optionally be removed.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER Name
    Global option set name.

    .PARAMETER Options
    Desired option list.

    .PARAMETER DisplayName
    Optional updated display label for the global option set.

    .PARAMETER Description
    Optional updated description label for the global option set.

    .PARAMETER MergeLabels
    Whether to keep text defined for languages not included in the Label. Default: true.

    .PARAMETER RemoveAbsentOptions
    Remove existing option values that are not present in the desired option list.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase.

    .EXAMPLE
    $options = @(
        (New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
        (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
    );
    Set-XrmGlobalOptionSetOptions -Name "new_priority" -Options $options -RemoveAbsentOptions;
#>
function Set-XrmGlobalOptionSetOptions {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OptionMetadata[]]
        $Options,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Label]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Label]
        $Description,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true,

        [Parameter(Mandatory = $false)]
        [switch]
        $RemoveAbsentOptions,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $optionSet = Get-XrmGlobalOptionSet -XrmClient $XrmClient -Name $Name;

        if ($PSBoundParameters.ContainsKey('DisplayName') -or $PSBoundParameters.ContainsKey('Description')) {
            if ($PSBoundParameters.ContainsKey('DisplayName')) {
                $optionSet.DisplayName = $DisplayName;
            }
            if ($PSBoundParameters.ContainsKey('Description')) {
                $optionSet.Description = $Description;
            }

            $setParams = @{
                XrmClient         = $XrmClient;
                OptionSetMetadata = $optionSet;
                MergeLabels       = $MergeLabels;
            };
            if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
                $setParams['SolutionUniqueName'] = $SolutionUniqueName;
            }

            Set-XrmGlobalOptionSet @setParams | Out-Null;
        }

        $syncParams = @{
            XrmClient    = $XrmClient;
            OptionSetName = $Name;
            ExistingOptions = $optionSet.Options;
            Options      = $Options;
            MergeLabels  = $MergeLabels;
            RemoveAbsentOptions = $RemoveAbsentOptions;
        };
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $syncParams['SolutionUniqueName'] = $SolutionUniqueName;
        }

        Sync-XrmOptionSetOptionsInternal @syncParams;

        Get-XrmGlobalOptionSet -XrmClient $XrmClient -Name $Name;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmGlobalOptionSetOptions -Alias *;
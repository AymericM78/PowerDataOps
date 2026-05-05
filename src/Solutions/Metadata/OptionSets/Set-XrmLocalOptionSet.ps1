<#
    .SYNOPSIS
    Synchronize the local options of a choice column.

    .DESCRIPTION
    Update the list of options of an existing local choice or multichoice column from a typed
    OptionMetadata list. Existing values are updated with Set-XrmOptionSetValue, missing values
    are created with Add-XrmOptionSetValue, and extra values can optionally be removed.

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER AttributeLogicalName
    Choice or multichoice attribute logical name.

    .PARAMETER Options
    Desired option list.

    .PARAMETER MergeLabels
    Whether to keep text defined for languages not included in the Label. Default: true.

    .PARAMETER RemoveAbsentOptions
    Remove existing option values that are not present in the desired option list.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.AttributeMetadata.

    .EXAMPLE
    $options = @(
        (New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
        (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
    );
    Set-XrmLocalOptionSet -EntityLogicalName "account" -AttributeLogicalName "new_priority" -Options $options -RemoveAbsentOptions;
#>
function Set-XrmLocalOptionSet {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.AttributeMetadata])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AttributeLogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.OptionMetadata[]]
        $Options,

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
        $column = Get-XrmColumn -XrmClient $XrmClient -EntityLogicalName $EntityLogicalName -LogicalName $AttributeLogicalName;
        $isSupportedType = ($column -is [Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]) -or ($column -is [Microsoft.Xrm.Sdk.Metadata.MultiSelectPicklistAttributeMetadata]);
        if (-not $isSupportedType) {
            throw "Column '$EntityLogicalName.$AttributeLogicalName' must be a picklist or multi-select picklist attribute.";
        }
        if ($null -eq $column.OptionSet -or $column.OptionSet.IsGlobal) {
            throw "Column '$EntityLogicalName.$AttributeLogicalName' does not use a local option set.";
        }

        $syncParams = @{
            XrmClient            = $XrmClient;
            EntityLogicalName    = $EntityLogicalName;
            AttributeLogicalName = $AttributeLogicalName;
            ExistingOptions      = $column.OptionSet.Options;
            Options              = $Options;
            MergeLabels          = $MergeLabels;
            RemoveAbsentOptions  = $RemoveAbsentOptions;
        };
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $syncParams['SolutionUniqueName'] = $SolutionUniqueName;
        }

        Sync-XrmOptionSetOptionsInternal @syncParams;

        Get-XrmColumn -XrmClient $XrmClient -EntityLogicalName $EntityLogicalName -LogicalName $AttributeLogicalName;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmLocalOptionSet -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmLocalOptionSet -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}
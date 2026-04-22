function Sync-XrmOptionSetOptionsInternal {
    param(
        [Parameter(Mandatory = $false)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $false)]
        [string]
        $OptionSetName,

        [Parameter(Mandatory = $false)]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [string]
        $AttributeLogicalName,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.OptionMetadata[]]
        $ExistingOptions = @(),

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

    $usesGlobalOptionSet = -not [string]::IsNullOrWhiteSpace($OptionSetName);
    if (-not $usesGlobalOptionSet -and ([string]::IsNullOrWhiteSpace($EntityLogicalName) -or [string]::IsNullOrWhiteSpace($AttributeLogicalName))) {
        throw "Provide either OptionSetName or both EntityLogicalName and AttributeLogicalName.";
    }

    $existingByValue = @{};
    foreach ($existingOption in $ExistingOptions) {
        if ($null -eq $existingOption -or $null -eq $existingOption.Value) {
            continue;
        }

        $existingByValue[[int]$existingOption.Value] = $existingOption;
    }

    $desiredByValue = @{};
    $desiredValuesInOrder = New-Object System.Collections.Generic.List[int];
    foreach ($option in $Options) {
        if ($null -eq $option.Value) {
            throw "Each option must define a Value for synchronization.";
        }

        $value = [int]$option.Value;
        if ($desiredByValue.ContainsKey($value)) {
            throw "Duplicate option value '$value' is not allowed in the desired option list.";
        }

        $desiredByValue[$value] = $option;
        $desiredValuesInOrder.Add($value) | Out-Null;
    }

    foreach ($value in $desiredValuesInOrder) {
        $option = $desiredByValue[$value];
        $commonParams = @{
            XrmClient = $XrmClient;
            Value     = $value;
            Label     = $option.Label;
        };

        if ($usesGlobalOptionSet) {
            $commonParams['OptionSetName'] = $OptionSetName;
        }
        else {
            $commonParams['EntityLogicalName'] = $EntityLogicalName;
            $commonParams['AttributeLogicalName'] = $AttributeLogicalName;
        }

        if ($null -ne $option.Description) {
            $commonParams['Description'] = $option.Description;
        }
        if (-not [string]::IsNullOrWhiteSpace($option.Color)) {
            $commonParams['Color'] = $option.Color;
        }
        if (-not [string]::IsNullOrWhiteSpace($option.ExternalValue)) {
            $commonParams['ExternalValue'] = $option.ExternalValue;
        }
        if ($null -ne $option.ParentValues) {
            $commonParams['ParentValues'] = $option.ParentValues;
        }
        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $commonParams['SolutionUniqueName'] = $SolutionUniqueName;
        }

        if ($existingByValue.ContainsKey($value)) {
            $setParams = @{};
            foreach ($entry in $commonParams.GetEnumerator()) {
                $setParams[$entry.Key] = $entry.Value;
            }
            $setParams['MergeLabels'] = $MergeLabels;
            Set-XrmOptionSetValue @setParams | Out-Null;
        }
        else {
            Add-XrmOptionSetValue @commonParams | Out-Null;
        }
    }

    if ($RemoveAbsentOptions) {
        foreach ($value in ($existingByValue.Keys | Sort-Object)) {
            if ($desiredByValue.ContainsKey($value)) {
                continue;
            }

            $removeParams = @{
                XrmClient = $XrmClient;
                Value     = $value;
            };

            if ($usesGlobalOptionSet) {
                $removeParams['OptionSetName'] = $OptionSetName;
            }
            else {
                $removeParams['EntityLogicalName'] = $EntityLogicalName;
                $removeParams['AttributeLogicalName'] = $AttributeLogicalName;
            }

            if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
                $removeParams['SolutionUniqueName'] = $SolutionUniqueName;
            }

            Remove-XrmOptionSetValue @removeParams | Out-Null;
        }
    }

    if ($desiredValuesInOrder.Count -gt 0) {
        $orderParams = @{
            XrmClient = $XrmClient;
            Values    = $desiredValuesInOrder.ToArray();
        };

        if ($usesGlobalOptionSet) {
            $orderParams['OptionSetName'] = $OptionSetName;
        }
        else {
            $orderParams['EntityLogicalName'] = $EntityLogicalName;
            $orderParams['AttributeLogicalName'] = $AttributeLogicalName;
        }

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $orderParams['SolutionUniqueName'] = $SolutionUniqueName;
        }

        Set-XrmOptionSetOrder @orderParams | Out-Null;
    }
}
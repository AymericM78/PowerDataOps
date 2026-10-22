<#
    .SYNOPSIS
    Update a column in Microsoft Dataverse.

    .DESCRIPTION
    Update an existing attribute / column metadata using UpdateAttributeRequest. The requirement level is set through the Web API (see RequiredLevel).

    .PARAMETER XrmClient
    Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)

    .PARAMETER EntityLogicalName
    Table / Entity logical name.

    .PARAMETER Attribute
    The AttributeMetadata object with updated properties. On an existing column, the platform ignores the RequiredLevel carried by the metadata: use RequiredLevel.

    .PARAMETER SolutionUniqueName
    Solution unique name context for the update.

    .PARAMETER MergeLabels
    Whether to merge labels. Default: true. With DisplayNameLabels or DescriptionLabels, the current labels of the other languages are read and sent too: the platform would otherwise copy the given text into the language of the caller when it is missing.

    .PARAMETER IsAuditEnabled
    Whether auditing is enabled on the column. When specified, overrides the value set on the AttributeMetadata.
    
    .PARAMETER EnableForInteractiveExperience
    Enables the column for interactive dashboards (sets IsGlobalFilterEnabled and IsSortableEnabled).

    .PARAMETER DisplayNameLabels
    Hashtable of language code to display name for multilingual labels. When provided, overrides the DisplayName set on the AttributeMetadata. Example: @{ 1033 = "Project Code"; 1036 = "Code projet" }

    .PARAMETER DescriptionLabels
    Hashtable of language code to description for multilingual labels. When provided, overrides the Description set on the AttributeMetadata.

    .PARAMETER LogicalName
    Column logical name, instead of Attribute: a minimal metadata of the column type is sent, carrying only the given settings (the platform validates every property the request carries).

    .PARAMETER RequiredLevel
    Requirement level: None, Recommended, ApplicationRequired. The organization service accepts it on an existing column without applying it: after the update of the other settings, the column definition is read through the Web API (strong consistency, past the metadata cache) and sent back with the new level (PUT), then read again. Raises an error when the column does not allow it to change (RequiredLevel.CanBeChanged), and when the level read back is not the one asked.

    .PARAMETER MinValue
    Minimum value of a whole number, decimal, float or currency column. The other bound is kept when not given.

    .PARAMETER MaxValue
    Maximum value of a whole number, decimal, float or currency column. The other bound is kept when not given.

    .OUTPUTS
    Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateAttribute response.

    .EXAMPLE
    $attr = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
    $attr.DisplayName = New-XrmLabel -Text "Project Code";
    Set-XrmColumn -EntityLogicalName "account" -Attribute $attr;

    .EXAMPLE
    $attr = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
    Set-XrmColumn -EntityLogicalName "account" -Attribute $attr -DisplayNameLabels @{ 1033 = "Project Code"; 1036 = "Code projet" };

    .EXAMPLE
    Set-XrmColumn -XrmClient $xrmClient -EntityLogicalName "account" -LogicalName "new_score" -RequiredLevel ApplicationRequired -MinValue 0 -MaxValue 1000;

    .LINK
    https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmColumn.md
#>
function Set-XrmColumn {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Microsoft.Xrm.Sdk.OrganizationResponse])]
    param
    (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $EntityLogicalName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Microsoft.Xrm.Sdk.Metadata.AttributeMetadata]
        $Attribute,

        [Parameter(Mandatory = $false)]
        [string]
        $SolutionUniqueName,

        [Parameter(Mandatory = $false)]
        [bool]
        $MergeLabels = $true,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsAuditEnabled,

        [Parameter(Mandatory = $false)]
        [switch]
        $EnableForInteractiveExperience,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $DisplayNameLabels,

        [Parameter(Mandatory = $false)]
        [Hashtable]
        $DescriptionLabels,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]
        $RequiredLevel,

        [Parameter(Mandatory = $false)]
        [double]
        $MinValue,

        [Parameter(Mandatory = $false)]
        [double]
        $MaxValue
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        if (-not $PSBoundParameters.ContainsKey('Attribute') -and -not $PSBoundParameters.ContainsKey('LogicalName')) {
            throw "Attribute or LogicalName is required.";
        }

        # The current definition is read when a check needs it, or to build a minimal metadata of the same type
        $mergeLabelsClientSide = $MergeLabels -and ($PSBoundParameters.ContainsKey('DisplayNameLabels') -or $PSBoundParameters.ContainsKey('DescriptionLabels'));
        $needsCurrent = $mergeLabelsClientSide -or $PSBoundParameters.ContainsKey('LogicalName') -or $PSBoundParameters.ContainsKey('RequiredLevel') -or $PSBoundParameters.ContainsKey('MinValue') -or $PSBoundParameters.ContainsKey('MaxValue');
        $current = $null;
        if ($needsCurrent) {
            $columnName = $(if ($PSBoundParameters.ContainsKey('LogicalName')) { $LogicalName } else { $Attribute.LogicalName });
            $current = Get-XrmColumn -XrmClient $XrmClient -EntityLogicalName $EntityLogicalName -LogicalName $columnName -IfExists;
            if (-not $current) {
                throw "Column '$columnName' not found on table '$EntityLogicalName'.";
            }
        }
        if (-not $PSBoundParameters.ContainsKey('Attribute')) {
            $Attribute = [Activator]::CreateInstance($current.GetType());
            $Attribute.LogicalName = $current.LogicalName;
            $Attribute.SchemaName = $current.SchemaName;
        }

        if ($PSBoundParameters.ContainsKey('RequiredLevel')) {
            if ($null -ne $current.RequiredLevel -and -not $current.RequiredLevel.CanBeChanged -and $current.RequiredLevel.Value -ne $RequiredLevel) {
                throw "The requirement level of column '$($current.LogicalName)' cannot be changed (RequiredLevel.CanBeChanged is false).";
            }
            $Attribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new($RequiredLevel);
        }

        if ($PSBoundParameters.ContainsKey('MinValue') -or $PSBoundParameters.ContainsKey('MaxValue')) {
            $rangeTypes = @{
                "IntegerAttributeMetadata" = [int];
                "BigIntAttributeMetadata"  = [long];
                "DecimalAttributeMetadata" = [decimal];
                "DoubleAttributeMetadata"  = [double];
                "MoneyAttributeMetadata"   = [double];
            };
            $valueType = $rangeTypes[$current.GetType().Name];
            if (-not $valueType) {
                throw "Column '$($current.LogicalName)' ($($current.GetType().Name)) has no MinValue / MaxValue.";
            }
            # Both bounds are always sent, so the new range is checked as a whole
            $newMin = $(if ($PSBoundParameters.ContainsKey('MinValue')) { $MinValue } else { $current.MinValue });
            $newMax = $(if ($PSBoundParameters.ContainsKey('MaxValue')) { $MaxValue } else { $current.MaxValue });
            if ($null -ne $newMin -and $null -ne $newMax -and [double]$newMin -gt [double]$newMax) {
                throw "MinValue ($newMin) is greater than MaxValue ($newMax).";
            }
            if ($null -ne $newMin) { $Attribute.MinValue = $newMin -as $valueType; }
            if ($null -ne $newMax) { $Attribute.MaxValue = $newMax -as $valueType; }
        }

        if ($PSBoundParameters.ContainsKey('IsAuditEnabled')) {
            $Attribute.IsAuditEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($IsAuditEnabled);
        }

        if ($EnableForInteractiveExperience.IsPresent) {
            $Attribute.IsGlobalFilterEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($true);
            $Attribute.IsSortableEnabled = [Microsoft.Xrm.Sdk.BooleanManagedProperty]::new($true);
        }

        # With MergeLabels, the languages not given are sent with their current text: the platform
        # otherwise copies the given text into the language of the caller when that one is missing
        if ($PSBoundParameters.ContainsKey('DisplayNameLabels')) {
            $labels = $DisplayNameLabels;
            if ($mergeLabelsClientSide) {
                $labels = ConvertFrom-XrmLabel -Label $current.DisplayName;
                foreach ($languageCode in $DisplayNameLabels.Keys) { $labels[[int]$languageCode] = $DisplayNameLabels[$languageCode]; }
            }
            $Attribute.DisplayName = New-XrmLabel -Labels $labels;
        }

        if ($PSBoundParameters.ContainsKey('DescriptionLabels')) {
            $labels = $DescriptionLabels;
            if ($mergeLabelsClientSide) {
                $labels = ConvertFrom-XrmLabel -Label $current.Description;
                foreach ($languageCode in $DescriptionLabels.Keys) { $labels[[int]$languageCode] = $DescriptionLabels[$languageCode]; }
            }
            $Attribute.Description = New-XrmLabel -Labels $labels;
        }

        $request = [Microsoft.Xrm.Sdk.Messages.UpdateAttributeRequest]::new();
        $request.EntityName = $EntityLogicalName;
        $request.Attribute = $Attribute;
        $request.MergeLabels = $MergeLabels;

        if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
            $request.Parameters["SolutionUniqueName"] = $SolutionUniqueName;
        }

        $response = Invoke-XrmRequest -XrmClient $XrmClient -Request $request;

        # UpdateAttribute accepts the requirement level of an existing column and ignores it (known issue K17): a Web API PUT
        # of the column definition sets it. Both reads ask for strong consistency: the metadata cache answers the previous
        # definition for a while, and a PUT built from it would undo the update above.
        if ($null -ne $response -and $PSBoundParameters.ContainsKey('RequiredLevel')) {
            $definitionPath = "EntityDefinitions(LogicalName='$EntityLogicalName')/Attributes(LogicalName='$($current.LogicalName)')/Microsoft.Dynamics.CRM.$($current.GetType().Name)";
            $definition = Invoke-XrmWebApiRequestInternal -XrmClient $XrmClient -Method GET -Path $definitionPath -StrongConsistency -AsJson;
            $level = $definition.SelectToken("RequiredLevel.Value");
            if ($level.ToString() -ne $RequiredLevel.ToString()) {
                $level.Value = $RequiredLevel.ToString();
                $headers = @{ "MSCRM.MergeLabels" = "true" };
                if ($PSBoundParameters.ContainsKey('SolutionUniqueName')) {
                    $headers["MSCRM.SolutionUniqueName"] = $SolutionUniqueName;
                }
                Invoke-XrmWebApiRequestInternal -XrmClient $XrmClient -Method PUT -Path $definitionPath -Body $definition.ToString([Newtonsoft.Json.Formatting]::None) -Headers $headers | Out-Null;

                $updated = Invoke-XrmWebApiRequestInternal -XrmClient $XrmClient -Method GET -Path $definitionPath -StrongConsistency -AsJson;
                $heldLevel = $updated.SelectToken("RequiredLevel.Value").ToString();
                if ($heldLevel -ne $RequiredLevel.ToString()) {
                    throw "The platform accepted the requirement level of column '$($current.LogicalName)' but kept $heldLevel (asked: $RequiredLevel).";
                }
            }
        }
        $response;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function Set-XrmColumn -Alias *;

Register-ArgumentCompleter -CommandName Set-XrmColumn -ParameterName "EntityLogicalName" -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
    $validLogicalNames = Get-XrmEntitiesLogicalName;
    return $validLogicalNames | Where-Object { $_ -like "$wordToComplete*" };
}

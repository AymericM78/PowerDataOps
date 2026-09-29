<#
    Add a condition to a FilterExpression (QueryExpression.Criteria or LinkEntity.LinkCriteria).

    - Values are normalized with ConvertTo-XrmSdkValueInternal (PSObject wrappers break serialization).
    - An empty In matches no row: an always-false sub-filter (Null AND NotNull) is added, so the query
      still runs and returns nothing, whatever the parent filter operator.
    - An empty NotIn matches every row: no condition is added.
#>
function Add-XrmFilterConditionInternal {
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.FilterExpression]
        $Filter,

        [Parameter(Mandatory = $true)]
        [String]
        $Field,

        [Parameter(Mandatory = $true)]
        [Microsoft.Xrm.Sdk.Query.ConditionOperator]
        $Condition,

        [Parameter(Mandatory = $true)]
        [bool]
        $HasValues,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.Object[]]
        $Values,

        [Parameter(Mandatory = $false)]
        [bool]
        $CompareFieldValue = $false
    )

    if (-not $HasValues) {
        $Filter.AddCondition($Field, $Condition);
        return;
    }

    if ($null -eq $Values) {
        $Filter.AddCondition($Field, $Condition, $Values);
        return;
    }

    if ($Values.Count -eq 0) {
        if ($Condition -eq [Microsoft.Xrm.Sdk.Query.ConditionOperator]::In) {
            $noRowFilter = $Filter.AddFilter([Microsoft.Xrm.Sdk.Query.LogicalOperator]::And);
            $noRowFilter.AddCondition($Field, [Microsoft.Xrm.Sdk.Query.ConditionOperator]::Null);
            $noRowFilter.AddCondition($Field, [Microsoft.Xrm.Sdk.Query.ConditionOperator]::NotNull);
            return;
        }
        if ($Condition -eq [Microsoft.Xrm.Sdk.Query.ConditionOperator]::NotIn) {
            return;
        }
    }

    $sdkValues = ConvertTo-XrmSdkValueInternal -Value $Values;
    $conditionValues = [object[]]::new($sdkValues.Length);
    [System.Array]::Copy($sdkValues, $conditionValues, $sdkValues.Length);

    if ($CompareFieldValue) {
        $Filter.AddCondition($Field, $Condition, $true, $conditionValues);
    }
    else {
        $Filter.AddCondition($Field, $Condition, $conditionValues);
    }
}

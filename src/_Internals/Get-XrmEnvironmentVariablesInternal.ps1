<#
    Read environment variable definitions with their value (override), in one query (left outer join), as summary objects:
    SchemaName, DisplayName, Type, DefinitionId, DefaultValue, ValueId, Value, EffectiveValue, HasOverride.
    EffectiveValue is the override when a value record exists (even empty), else the default value.
    Used by Get-XrmEnvironmentVariable, Get-XrmEnvironmentVariableDefinitions and Get-XrmEnvironmentVariableValue.
#>
function Get-XrmEnvironmentVariablesInternal {
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerPlatform.Dataverse.Client.ServiceClient]
        $XrmClient,

        [Parameter(Mandatory = $false)]
        [String]
        $Name
    )

    $typeNames = @{ 100000000 = "String"; 100000001 = "Number"; 100000002 = "Boolean"; 100000003 = "JSON"; 100000004 = "DataSource"; 100000005 = "Secret" };

    $query = New-XrmQueryExpression -LogicalName "environmentvariabledefinition" -Columns "schemaname", "displayname", "type", "defaultvalue";
    if ($Name) {
        $query = $query | Add-XrmQueryCondition -Field "schemaname" -Condition Equal -Values $Name;
    }
    $link = $query | Add-XrmQueryLink -ToEntityName "environmentvariablevalue" -FromAttributeName "environmentvariabledefinitionid" -ToAttributeName "environmentvariabledefinitionid" -JoinOperator LeftOuter -Alias "val";
    $link | Add-XrmQueryLinkColumns -Columns "value", "environmentvariablevalueid" | Out-Null;

    $rows = Get-XrmMultipleRecords -XrmClient $XrmClient -Query $query -AsEntity -AsArray;
    $seen = @{};
    foreach ($row in $rows) {
        # A definition has at most one value record; keep the first row if the join ever returns more
        if ($seen.ContainsKey($row.Id)) {
            continue;
        }
        $seen[$row.Id] = $true;

        $valueId = $row | Get-XrmAttributeValue -Name "val.environmentvariablevalueid" -Raw;
        $value = $row | Get-XrmAttributeValue -Name "val.value" -Raw;
        $hasOverride = ($null -ne $valueId);
        $typeCode = $row | Get-XrmAttributeValue -Name "type" -Raw;
        $defaultValue = $row | Get-XrmAttributeValue -Name "defaultvalue";
        [PSCustomObject]@{
            SchemaName     = $row | Get-XrmAttributeValue -Name "schemaname";
            DisplayName    = $row | Get-XrmAttributeValue -Name "displayname";
            Type           = $(if ($null -ne $typeCode -and $typeNames.ContainsKey([int]$typeCode)) { $typeNames[[int]$typeCode] } else { $typeCode });
            DefinitionId   = $row.Id;
            DefaultValue   = $defaultValue;
            ValueId        = $valueId;
            Value          = $value;
            EffectiveValue = $(if ($hasOverride) { [string]$value } else { $defaultValue });
            HasOverride    = $hasOverride;
        };
    }
}

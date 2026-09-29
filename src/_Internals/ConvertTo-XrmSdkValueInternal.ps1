<#
    Normalize a value before it is stored in an SDK object (entity attribute, request parameter, query condition).

    - Unwraps the PSObject adapter that PowerShell keeps around objects built with New-Object or emitted by a
      pipeline: the SDK serializer rejects it ("Type 'System.Management.Automation.PSObject' cannot be serialized").
    - Unwraps each item of an array, then types a homogeneous Object[] (e.g. @($query) => QueryExpression[]):
      typed request fields reject Object[] ("'Object[]' does not match expected type 'QueryExpression[]'").

    $null and PSCustomObject values are returned unchanged.
    Arrays are returned with the unary comma: capture the result in a variable, never pipe it.
#>
function ConvertTo-XrmSdkValueInternal {
    param(
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $Value
    )

    if ($null -eq $Value) {
        return $null;
    }

    if ($Value -is [psobject] -and $Value.PSObject.BaseObject -isnot [System.Management.Automation.PSCustomObject]) {
        $Value = $Value.PSObject.BaseObject;
    }

    if ($Value -isnot [object[]]) {
        return ,$Value;
    }

    $items = [object[]]::new($Value.Length);
    $itemType = $null;
    $homogeneous = ($Value.Length -gt 0);
    for ($i = 0; $i -lt $Value.Length; $i++) {
        $item = $Value[$i];
        if ($item -is [psobject] -and $item.PSObject.BaseObject -isnot [System.Management.Automation.PSCustomObject]) {
            $item = $item.PSObject.BaseObject;
        }
        $items[$i] = $item;

        if ($null -eq $item -or $item -is [System.Management.Automation.PSCustomObject]) {
            $homogeneous = $false;
        }
        elseif ($null -eq $itemType) {
            $itemType = $item.GetType();
        }
        elseif ($item.GetType() -ne $itemType) {
            $homogeneous = $false;
        }
    }

    if (-not $homogeneous) {
        return ,$items;
    }

    $typedItems = [System.Array]::CreateInstance($itemType, $items.Length);
    [System.Array]::Copy($items, $typedItems, $items.Length);
    return ,$typedItems;
}

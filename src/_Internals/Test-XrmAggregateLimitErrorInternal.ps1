<#
    Tell whether an error is the platform refusing an aggregate query above 50,000 rows (AggregateQueryRecordLimit, 0x8004E023).
    The refusal is reported with different texts ("AggregateQueryRecordLimit exceeded", "The maximum record limit of 50000 is exceeded"):
    the fault error code is checked first, then both texts, on the whole exception chain.
    Used by Get-XrmRecordCount to fall back to paging.
#>
function Test-XrmAggregateLimitErrorInternal {
    param(
        [Parameter(Mandatory = $true)]
        [System.Exception]
        $Exception
    )

    $aggregateLimitErrorCode = -2147164125;
    $patterns = @("AggregateQueryRecordLimit", "maximum record limit");

    $current = $Exception;
    while ($null -ne $current) {
        if ($current.PSObject.Properties["Detail"] -and $null -ne $current.Detail -and $current.Detail.PSObject.Properties["ErrorCode"]) {
            if ($current.Detail.ErrorCode -eq $aggregateLimitErrorCode) {
                return $true;
            }
        }
        if ($current.HResult -eq $aggregateLimitErrorCode) {
            return $true;
        }
        foreach ($pattern in $patterns) {
            if (-not [string]::IsNullOrWhiteSpace($current.Message) -and $current.Message.IndexOf($pattern, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
                return $true;
            }
        }
        $current = $current.InnerException;
    }
    return $false;
}

function Test-XrmNotFoundError {
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    $messages = New-Object System.Collections.Generic.List[string];
    $exception = $ErrorRecord.Exception;
    while ($null -ne $exception) {
        if (-not [string]::IsNullOrWhiteSpace($exception.Message)) {
            $messages.Add($exception.Message) | Out-Null;
        }

        $exception = $exception.InnerException;
    }

    if (-not [string]::IsNullOrWhiteSpace($ErrorRecord.ToString())) {
        $messages.Add($ErrorRecord.ToString()) | Out-Null;
    }

    if ($messages.Count -eq 0) {
        return $false;
    }

    $notFoundPatterns = @(
        "could not find",
        "not found",
        "does not exist",
        "doesn't exist",
        "cannot find",
        "was not found"
    );

    foreach ($message in $messages) {
        foreach ($pattern in $notFoundPatterns) {
            if ($message.IndexOf($pattern, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
                return $true;
            }
        }
    }

    return $false;
}
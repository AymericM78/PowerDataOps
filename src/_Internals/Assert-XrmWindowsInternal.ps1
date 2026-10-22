<#
    Raise an error naming the feature when the module runs on Linux or macOS, for the commands that need Windows (COM automation,
    Windows executables, browser profiles and registry). Without it they failed with an unrelated message
    (e.g. "A parameter cannot be found that matches parameter name 'ComObject'"). The Platform parameter exists for the tests.
#>
function Assert-XrmWindowsInternal {
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Feature,

        [Parameter(Mandatory = $false)]
        [String]
        $Alternative,

        [Parameter(Mandatory = $false)]
        [System.PlatformID]
        $Platform = [System.Environment]::OSVersion.Platform
    )

    if ($Platform -eq [System.PlatformID]::Win32NT) {
        return;
    }
    $message = "$Feature is only available on Windows.";
    if ($Alternative) {
        $message += " $Alternative";
    }
    throw $message;
}

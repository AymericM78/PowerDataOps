<#
    Folder of the user's application data: APPDATA on Windows. On Linux and macOS, where APPDATA does not exist, the user's configuration
    folder (~/.config, or XDG_CONFIG_HOME), and the temporary folder when there is no home directory (some containers).
    A path built from "$env:APPDATA" there is relative ("\PowerDataOps"), so the module folder and its logs landed in the current directory.
#>
function Get-XrmAppDataPathInternal {
    param()

    $appDataPath = $env:APPDATA;
    if ([string]::IsNullOrWhiteSpace($appDataPath)) {
        $appDataPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData);
    }
    if ([string]::IsNullOrWhiteSpace($appDataPath)) {
        $appDataPath = [System.IO.Path]::GetTempPath();
    }
    $appDataPath;
}

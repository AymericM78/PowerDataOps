. "$PsScriptRoot\..\_Internals\BrowserManager.ps1"
<#
    .SYNOPSIS
    Configure browser according to Dataverse environnements.

    .DESCRIPTION
    Provision or update Chrome or Edge (based on chromium) profile with all dataverse apps and Power Platform usefull links.

    .PARAMETER ProfileName
    Name of existing or new browser profile.
    
    .PARAMETER BrowserShortCutsPath
    Folder path where to store profile shortcut (.lnk).
    
    .PARAMETER IsChrome
    Indicates if browser is Google Chrome. (Default: true)
    Use false to switch to Edge.
    
    .PARAMETER OverrideConnectionStringFormat
    Provide the ConnectionString template in order to access to instances with different credentials.

    .PARAMETER Extensions
    Define chrome extensions identifiers to install.

    .PARAMETER AppIgnoredList
    Filter app list during favorite provisionning.

    .PARAMETER ChromeDefaultProfilesPath
    Folder path where to store Chrome profile folder.

    .PARAMETER ChromeX64AppPath
    Chrome executable path for 64 bits version.

    .PARAMETER ChromeX32AppPath
    Chrome executable path for 32 bits version.

    .PARAMETER EdgeDefaultProfilesPath
    Folder path where to store Edge profile folder.

    .PARAMETER EdgeAppPath
    Edge executable path.
#>
function Export-XrmConnectionToBrowser {
    [CmdletBinding()]
    param
    (        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   
        [String]
        $ProfileName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]   
        [String]
        $BrowserShortCutsPath,

        [Parameter(Mandatory = $false)]
        [bool]
        $IsChrome = $true,       

        [Parameter(Mandatory = $false)]
        [String]
        $OverrideConnectionStringFormat = "",

        [Parameter(Mandatory = $false)]
        [string[]]
        $Extensions = @("eadknamngiibbmjdfokmppfooolhdidc", "bjnkkhimoaclnddigpphpgkfgeggokam"),        

        [Parameter(Mandatory = $false)]
        [String[]]
        $AppIgnoredList = @(),

        [Parameter(Mandatory = $false)]
        [string]
        $ChromeDefaultProfilesPath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\",

        [Parameter(Mandatory = $false)]
        [string]
        $ChromeX64AppPath = "C:\Program Files\Google\Chrome\Application\chrome.exe",

        [Parameter(Mandatory = $false)]
        [string]
        $ChromeX32AppPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
        
        [Parameter(Mandatory = $false)]
        [string]
        $EdgeDefaultProfilesPath = "$($env:LOCALAPPDATA)\Microsoft\Edge SxS\User Data\",

        [Parameter(Mandatory = $false)]
        [string]
        $EdgeAppPath = "$($env:LOCALAPPDATA)\Microsoft\Edge SxS\Application\msedge.exe"

    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {

        if ($isChrome) {
            $browserProfilesPath = $ChromeDefaultProfilesPath;
            if (Test-Path -Path $ChromeX64AppPath) {
                $browserAppPath = $ChromeX64AppPath;
            }
            elseif (Test-Path -Path $ChromeX32AppPath) {
                $browserAppPath = $ChromeX32AppPath;
            }
            else {
                throw "Chrome application path not found!";
            }
        }
        else {
            $browserProfilesPath = $EdgeDefaultProfilesPath;
            $browserAppPath = $EdgeAppPath;
        }

        # Provision profile folder
        $profilePath = [IO.Path]::Combine($browserProfilesPath, $profileName);
        if (-not(Test-Path -Path $profilePath)) {
            New-Item -ItemType Directory -Path $browserProfilesPath -Name $profileName -Force -ErrorAction Ignore | Out-Null;

            # Create shrotcut
            Add-BrowserShortcut -BrowserShortCutsPath $BrowserShortCutsPath -BrowserAppPath $browserAppPath -ProfileName $profileName;
    
            # Start browser for folder initialization
            Start-Browser -BrowserAppPath $browserAppPath -ProfileName $profileName;
            Start-Sleep -Seconds 5;
            
            # Configure chrome : Favorite bar
            Set-BrowserFavoriteBarEnabled -ProfileName $profileName -ProfilePath $profilePath;
        
            # Configure chrome : Extensions
            $Extensions | ForEach-Object {
                if ($isChrome) {
                    Add-ChromeExtension -ExtensionName $_;
                }
                else {        
                    Add-EdgeExtension -ExtensionName $_;
                }
            }
        }

        # Configure chrome : Add favorites
        $rootBookmark = Get-DefaultBookmark;
        
        # Retrieve CDS instances and add links to bookmark        
        $rootBookmark = Get-XrmFavorites -RootBookmark $rootBookmark -OverrideConnectionStringFormat $OverrideConnectionStringFormat -AppIgnoredList $AppIgnoredList;

        # Save favorites
        Save-BookMark -ProfilePath $profilePath -RootBookmark $rootBookmark;

        # Fix profile name
        $browserStateFilePath = "$browserProfilesPath\Local State";
        $localState = [IO.File]::ReadAllText($browserStateFilePath) | ConvertFrom-Json;
        $localState.profile.info_cache.$profileName.name = $profileName;
        $localState | ConvertTo-Json -Depth 32 | Out-File -FilePath $browserStateFilePath -Encoding utf8 -Force;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Export-XrmConnectionToBrowser -Alias *;
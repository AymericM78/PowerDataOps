# Command : `Export-XrmConnectionToBrowser` 

## Description

**Configure browser according to Dataverse environnements.** : Provision or update Chrome or Edge (based on chromium) profile with all dataverse apps and Power Platform usefull links.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ProfileName|String|1|true||Name of existing or new browser profile.
BrowserShortCutsPath|String|2|true||Folder path where to store profile shortcut (.lnk).
IsChrome|Boolean|3|false|True|Indicates if browser is Google Chrome. (Default: true)
Use false to switch to Edge.
OverrideConnectionStringFormat|String|4|false||Provide the ConnectionString template in order to access to instances with different credentials.
Extensions|String[]|5|false|@("eadknamngiibbmjdfokmppfooolhdidc", "bjnkkhimoaclnddigpphpgkfgeggokam")|Define chrome extensions identifiers to install.
AppIgnoredList|String[]|6|false|@()|Filter app list during favorite provisionning.
ChromeDefaultProfilesPath|String|7|false|"$($env:LOCALAPPDATA)\Google\Chrome\User Data\"|Folder path where to store Chrome profile folder.
ChromeX64AppPath|String|8|false|C:\Program Files\Google\Chrome\Application\chrome.exe|Chrome executable path for 64 bits version.
ChromeX32AppPath|String|9|false|C:\Program Files (x86)\Google\Chrome\Application\chrome.exe|Chrome executable path for 32 bits version.
EdgeDefaultProfilesPath|String|10|false|"$($env:LOCALAPPDATA)\Microsoft\Edge SxS\User Data\"|Folder path where to store Edge profile folder.
EdgeAppPath|String|11|false|"$($env:LOCALAPPDATA)\Microsoft\Edge SxS\Application\msedge.exe"|Edge executable path.


## Usage

```Powershell 
Export-XrmConnectionToBrowser [-ProfileName] <String> [-BrowserShortCutsPath] <String> [[-IsChrome] <Boolean>] [[-OverrideConnectionStringFormat] <String>] 
[[-Extensions] <String[]>] [[-AppIgnoredList] <String[]>] [[-ChromeDefaultProfilesPath] <String>] [[-ChromeX64AppPath] <String>] [[-ChromeX32AppPath] <String>] 
[[-EdgeDefaultProfilesPath] <String>] [[-EdgeAppPath] <String>] [<CommonParameters>]
``` 



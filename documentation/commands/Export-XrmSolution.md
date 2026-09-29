# Command : `Export-XrmSolution` 

## Description

**Export solution.** : Export given solution with given settings.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to export.
Managed|Boolean|3|false|False|Specify if solution should be export as managed or unmanaged. (Default: false = unmanaged)
ExportPath|String|4|false|$env:TEMP|Folder where the solution file is written. (Default: TEMP folder)
ExportCalendarSettings|Boolean|5|false|False|Specify if exported solution should include Calendar settings (Default: false)
ExportCustomizationSettings|Boolean|6|false|False|Specify if exported solution should include Customization settings (Default: false)
ExportEmailTrackingSettings|Boolean|7|false|False|Specify if exported solution should include Email Tracking settings (Default: false)
ExportAutoNumberingSettings|Boolean|8|false|False|Specify if exported solution should include AutoNumbering settings (Default: false)
ExportIsvConfig|Boolean|9|false|False|Specify if exported solution should include Isv settings (Default: false)
ExportOutlookSynchronizationSettings|Boolean|10|false|False|Specify if exported solution should include Outlook Synchronization settings (Default: false)
ExportGeneralSettings|Boolean|11|false|False|Specify if exported solution should include General settings (Default: false)
ExportMarketingSettings|Boolean|12|false|False|Specify if exported solution should include Marketing settings (Default: false)
ExportRelationshipRoles|Boolean|13|false|False|Specify if exported solution should include RelationshipRoles (Default: false)
AddVersionToFileName|Boolean|14|false|False|Specify if solution version number should be added to file name. (Default: false)
ForceSyncExport|SwitchParameter|named|false|False|Specify if solution should be exported synchronously. (Default: false)
TimeoutInMinutes|Int32|15|false|10|Maximum wait for the asynchronous export. (Default: 10)
Unpack|SwitchParameter|named|false|False|Extract the solution file into a folder and return the folder path instead of the file path.
UnpackPath|String|16|false||Folder to extract into, with Unpack. Files already there are overwritten. (Default: the solution file path without the .zip extension)

## Outputs
System.String. Path of the solution file, or of the extracted folder with Unpack.

## Usage

```Powershell 
Export-XrmSolution [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [[-Managed] <Boolean>] [[-ExportPath] <String>] [[-ExportCalendarSettings] <Boolean>] [[-ExportCustomizationSettings] <Boolean>] [[-ExportEmailTrackingSettings] <Boolean>] [[-ExportAutoNumberingSettings] <Boolean>] [[-ExportIsvConfig] <Boolean>] [[-ExportOutlookSynchronizationSettings] <Boolean>] [[-ExportGeneralSettings] <Boolean>] [[-ExportMarketingSettings] <Boolean>] [[-ExportRelationshipRoles] <Boolean>] [[-AddVersionToFileName] <Boolean>] [-ForceSyncExport] [[-TimeoutInMinutes] <Int32>] [-Unpack] [[-UnpackPath] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$zipPath = Export-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "ContosoCore" -ExportPath "C:\Temp";
``` 


```Powershell 
$folder = Export-XrmSolution -XrmClient $xrmClient -SolutionUniqueName "ContosoCore" -ExportPath "C:\Temp" -Unpack;
[xml]$customizations = Get-Content -Path (Join-Path $folder "customizations.xml") -Raw;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Export-XrmSolution.md



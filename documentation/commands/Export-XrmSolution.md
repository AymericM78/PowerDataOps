# Command : `Export-XrmSolution` 

## Description

**Export solution.** : Export given solution with given settings.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to export.
Managed|Boolean|3|false|False|Specify if solution should be export as managed or unmanaged. (Default: true = managed)
ExportPath|String|4|false|$env:TEMP|
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


## Usage

```Powershell 
Export-XrmSolution [[-XrmClient] <CrmServiceClient>] [-SolutionUniqueName] <String> [[-Managed] <Boolean>] [[-ExportPath] <String>] [[-ExportCalendarSettings] 
<Boolean>] [[-ExportCustomizationSettings] <Boolean>] [[-ExportEmailTrackingSettings] <Boolean>] [[-ExportAutoNumberingSettings] <Boolean>] [[-ExportIsvConfig] 
<Boolean>] [[-ExportOutlookSynchronizationSettings] <Boolean>] [[-ExportGeneralSettings] <Boolean>] [[-ExportMarketingSettings] <Boolean>] [[-ExportRelationshipRoles] 
<Boolean>] [[-AddVersionToFileName] <Boolean>] [<CommonParameters>]
``` 



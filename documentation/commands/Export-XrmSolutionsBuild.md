# Command : `Export-XrmSolutionsBuild` 

## Description

**Run build action to export solutions.** : This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
This cmdlet export given solutions in order to add them to build artifacts.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false|$env:CONNECTIONSTRING|Target instance connection string, use variable 'ConnectionString' from associated variable group.
ExportPath|String|2|false|$env:BUILD_ARTIFACTSTAGINGDIRECTORY|Folder path where solutions will be exported. (Default: Agent Artifacts Staging directory)
Solutions|String|3|false|$env:SOLUTIONS|Solution uniquenames that will be exported and then unpacked, use variable 'Solutions' from associated variable group.
Managed|Boolean|4|false|True|Specify if solution should be export as managed or unmanaged. (Default: true = managed)
ExportCalendarSettings|Boolean|5|false|False|Specify if exported solution should include Calendar settings (Default: false)
ExportCustomizationSettings|Boolean|6|false|False|Specify if exported solution should include Customization settings (Default: false)
ExportEmailTrackingSettings|Boolean|7|false|False|Specify if exported solution should include Email Tracking settings (Default: false)
ExportAutoNumberingSettings|Boolean|8|false|False|Specify if exported solution should include AutoNumbering settings (Default: false)
ExportIsvConfig|Boolean|9|false|False|Specify if exported solution should include Isv settings (Default: false)
ExportOutlookSynchronizationSettings|Boolean|10|false|False|Specify if exported solution should include Outlook Synchronization settings (Default: false)
ExportGeneralSettings|Boolean|11|false|False|Specify if exported solution should include General settings (Default: false)
ExportMarketingSettings|Boolean|12|false|False|Specify if exported solution should include Marketing settings (Default: false)
ExportRelationshipRoles|Boolean|13|false|False|Specify if exported solution should include RelationshipRoles (Default: false)

## Outputs

## Usage

```Powershell 
Export-XrmSolutionsBuild [[-ConnectionString] <String>] [[-ExportPath] <String>] [[-Solutions] <String>] [[-Managed] <Boolean>] [[-ExportCalendarSettings] <Boolean>] [[-ExportCustomizationSettings] <Boolean>] 
[[-ExportEmailTrackingSettings] <Boolean>] [[-ExportAutoNumberingSettings] <Boolean>] [[-ExportIsvConfig] <Boolean>] [[-ExportOutlookSynchronizationSettings] <Boolean>] [[-ExportGeneralSettings] <Boolean>] 
[[-ExportMarketingSettings] <Boolean>] [[-ExportRelationshipRoles] <Boolean>] [<CommonParameters>]
``` 



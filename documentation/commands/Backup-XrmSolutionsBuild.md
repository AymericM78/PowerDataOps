# Command : `Backup-XrmSolutionsBuild` 

## Description

**Run build action to unpack solutions** : This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
This cmdlet export given solutions and then start SolutionPackager extract action to working directory.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false|$env:CONNECTIONSTRING|Target instance connection string, use variable 'ConnectionString' from associated variable group.
UnpackPath|String|2|false|$env:SYSTEM_DEFAULTWORKINGDIRECTORY|Folder path where solutions will be extracted. (Default: Agent working directory)
Solutions|String|3|false|$env:SOLUTIONS|Solution uniquenames that will be exported and then unpacked, use variable 'Solutions' from associated variable group.
Managed|Boolean|4|false|False|Specify if solution should be export as managed or unmanaged. (Default: false = unmanaged)
DefaultExportPath|String|5|false|$env:TEMP|Folder path where solutions will be exported before unpacked. (Default: Agent temp directory)


## Usage

```Powershell 
Backup-XrmSolutionsBuild [[-ConnectionString] <String>] [[-UnpackPath] <String>] [[-Solutions] <String>] [[-Managed] <Boolean>] [[-DefaultExportPath] <String>] 
[<CommonParameters>]
``` 



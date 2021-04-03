# Command : `Import-XrmSolutionsBuild` 

## Description

**Run build action to import solutions** : This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
This cmdlet import given solutions from artifacts.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false|$env:CONNECTIONSTRING|Target instance connection string, use variable 'ConnectionString' from associated variable group.
ArtifactsPath|String|2|false|"$($Env:SYSTEM_DEFAULTWORKINGDIRECTORY)\Solutions\drop\"|Folder path where solutions will be imported. (Default: Agent default working directory)
SolutionsImportOrder|String|3|false|$($env:SOLUTIONS_IMPORTORDER)|Solution uniquenames that will be imported in given order, use variable 'Solutions.ImportOrder' from associated variable group.
ClearPluginStepsAndTypes|Boolean|4|false|True|Indicates if plugins need to be unregistered prior solution import. (Default: true)
PluginAssemblyName|String|5|false|Plugins|Specify plugin assembly name for plugin removal operation. (Default: Plugins)
Upgrade|Boolean|6|false|False|


## Usage

```Powershell 
Import-XrmSolutionsBuild [[-ConnectionString] <String>] [[-ArtifactsPath] <String>] [[-SolutionsImportOrder] <String>] [[-ClearPluginStepsAndTypes] <Boolean>] 
[[-PluginAssemblyName] <String>] [[-Upgrade] <Boolean>] [<CommonParameters>]
``` 



# Command : `Invoke-XrmSolutionPackager` 

## Description

**Run solution packager tool.** : Pack or unpack given solution file with Solution Packager.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
SolutionFilePath|String|1|true||Full path to solution file (.zip).
SolutionPackagerExeFilePath|String|2|false|"$PSScriptRoot\bin\SolutionPackager.exe"|Full path to solution packager executable. (Default : $PSScriptRoot\bin\SolutionPackager.exe)
Action|String|3|true||The action to perform.
The action can be either to extract a solution .zip file to a folder, or to pack a folder into a .zip file.
PackageType|String|4|false|Both|The type of package to process. (Default: Both)
This argument may be omitted in most occasions because the package type can be read from inside the .zip file or component files. 
When extracting and Both is specified, managed and unmanaged solution .zip files must be present and are processed into a single folder. 
When packing and Both is specified, managed and unmanaged solution .zip files will be produced from one folder.
FolderPath|String|5|false||Full path to a folder where solution will be extracted or packed. 
When extracting, this folder is created and populated with component files. 
When packing, this folder must already exist and contain previously extracted component files.
ErrorLevel|String|6|false|Error|Indicates the level of logging information to output. (Default: Error)
LogFilePath|String|7|false|"$($env:TEMP)\SolutionPackager.log"|Full path to log file. If the file already exists, new logging information is appended to the file.


## Usage

```Powershell 
Invoke-XrmSolutionPackager [-SolutionFilePath] <String> [[-SolutionPackagerExeFilePath] <String>] [-Action] <String> [[-PackageType] <String>] [[-FolderPath] 
<String>] [[-ErrorLevel] <String>] [[-LogFilePath] <String>] [<CommonParameters>]
``` 



# Command : `Set-XrmSolutionsVersionBuild` 

## Description

**Run build action to upgrade solutions versions** : This cmdlet is designed to be fully intergrated in Az DevOps pipeline. 
This cmdlet update solution version number.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ConnectionString|String|1|false|$env:CONNECTIONSTRING|Target instance connection string, use variable 'ConnectionString' from associated variable group.
BuildId|String|2|false|$env:BUILD_BUILDID|Unique ID for current build. (Default : Azure DevOps BuildId variable)
Version|String|3|false|$env:VERSION|Version number format. Use variable 'Version' from associated variable group. 
And replace 'X' by BuildId or DateTime format (like 'yyyy.MM.dd.hh' by '2021.02.28.17').
Solutions|String|4|false|$env:SOLUTIONS|Solution uniquenames to update, use variable 'Solutions' from associated variable group.


## Usage

```Powershell 
Set-XrmSolutionsVersionBuild [[-ConnectionString] <String>] [[-BuildId] <String>] [[-Version] <String>] [[-Solutions] <String>] [<CommonParameters>]
``` 



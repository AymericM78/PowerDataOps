# Command : `Import-XrmSolution` 

## Description

**Import solution.** : Performs solution import to target instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to import.
SolutionFilePath|String|3|true||Full path to solution file (.zip).
PublishWorkflows|Boolean|4|false|True|Gets or sets whether any processes (workflows) included in the solution should be activated after they are imported. (Default : true)
OverwriteUnmanagedCustomizations|Boolean|5|false|True|Gets or sets whether any unmanaged customizations that have been applied over existing managed solution components should be overwritten. (Default : true)
ConvertToManaged|Boolean|6|false|False|Direct the system to convert any matching unmanaged customizations into your managed solution. (Default : false)
Upgrade|Boolean|7|false|False|Gets or sets whether to import the solution as a holding solution staged for upgrade. (Default : false)
SkipProductUpdateDependencies|Boolean|8|false|True|Gets or sets whether enforcement of dependencies related to product updates should be skipped. (Default : false)


## Usage

```Powershell 
Import-XrmSolution [[-XrmClient] <CrmServiceClient>] [-SolutionUniqueName] <String> [-SolutionFilePath] <String> [[-PublishWorkflows] <Boolean>] 
[[-OverwriteUnmanagedCustomizations] <Boolean>] [[-ConvertToManaged] <Boolean>] [[-Upgrade] <Boolean>] [[-SkipProductUpdateDependencies] <Boolean>] 
[<CommonParameters>]
``` 



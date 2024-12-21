# Command : `Set-XrmSolutionVersion` 

## Description

**Set solution version.** : Update specified solution by its uniquename with given version number.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to update.
Version|String|3|true||Version number to set.


## Usage

```Powershell 
Set-XrmSolutionVersion [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-Version] <String> [<CommonParameters>]
``` 



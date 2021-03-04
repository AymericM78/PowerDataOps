# Command : `Get-XrmSolutionVersion` 

## Description

**Get solution version.** : Get version number from given solution.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to retrieve.

## Outputs

## Usage

```Powershell 
Get-XrmSolutionVersion [[-XrmClient] <CrmServiceClient>] [-SolutionUniqueName] <String> [<CommonParameters>]
``` 



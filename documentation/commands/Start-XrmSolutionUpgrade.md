# Command : `Start-XrmSolutionUpgrade` 

## Description

**Start delete and promote operation for solution.** : Replace managed solution by new one after import.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to upgrade.

## Outputs

## Usage

```Powershell 
Start-XrmSolutionUpgrade [[-XrmClient] <CrmServiceClient>] [-SolutionUniqueName] <String> [<CommonParameters>]
``` 



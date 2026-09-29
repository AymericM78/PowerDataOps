# Command : `Start-XrmSolutionUpgrade` 

## Description

**Start delete and promote operation for solution.** : Replace managed solution by new one after import.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
SolutionUniqueName|String|2|true||Solution unique name to upgrade.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||


## Usage

```Powershell 
Start-XrmSolutionUpgrade [[-XrmClient] <ServiceClient>] [-SolutionUniqueName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 



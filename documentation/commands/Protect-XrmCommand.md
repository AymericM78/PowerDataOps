# Command : `Protect-XrmCommand` 

## Description

**Protect command from API Limit issues.** : This cmdlet provide a core method for all API calls to Microsoft Dataverse.
The aim is to provide a retry pattern to prevent technical issues as API Limits or network connectivity

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
ScriptBlock|ScriptBlock|1|true||Command to run against Microsoft Dataverse API.
Maximum|Int32|2|false|0|Maximum tries below raising an error.


## Usage

```Powershell 
Protect-XrmCommand [-ScriptBlock] <ScriptBlock> [[-Maximum] <Int32>] [<CommonParameters>]
``` 



# Command : `Watch-XrmCurrentSolutionImport` 

## Description

**Monitor current solution import.** : Poll latest solution import status until its done and display progress.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)


## Usage

```Powershell 
Watch-XrmCurrentSolutionImport [[-XrmClient] <ServiceClient>] [<CommonParameters>]
``` 



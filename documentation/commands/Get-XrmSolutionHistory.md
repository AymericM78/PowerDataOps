# Command : `Get-XrmSolutionHistory` 

## Description

**Retrieve solutions history.** : Get solution operation logs.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Take|Int32|2|false|50|Number of logs to retrieve. (Default : 50)


## Usage

```Powershell 
Get-XrmSolutionHistory [[-XrmClient] <ServiceClient>] [[-Take] <Int32>] [<CommonParameters>]
``` 



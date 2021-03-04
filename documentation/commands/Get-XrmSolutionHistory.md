# Command : `Get-XrmSolutionHistory` 

## Description

**Retrieve solutions history.** : Get solution operation logs.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Take|Int32|2|false|50|Number of logs to retrieve. (Default : 50)

## Outputs

## Usage

```Powershell 
Get-XrmSolutionHistory [[-XrmClient] <CrmServiceClient>] [[-Take] <Int32>] [<CommonParameters>]
``` 



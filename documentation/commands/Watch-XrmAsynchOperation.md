# Command : `Watch-XrmAsynchOperation` 

## Description

**Monitor async operation completion.** : Poll status from asynchoperation id until its done.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AsyncOperationId|Guid|2|true||System job unique identifier.
PollingIntervalSeconds|Int32|3|false|5|Delay between each status check.
ScriptBlock|ScriptBlock|4|false||Command to execute during each poll with asyncoperation info.
TimeoutInMinutes|Int32|5|false|60|


## Usage

```Powershell 
Watch-XrmAsynchOperation [[-XrmClient] <ServiceClient>] [-AsyncOperationId] <Guid> [[-PollingIntervalSeconds] <Int32>] [[-ScriptBlock] <ScriptBlock>] [[-TimeoutInMinutes] <Int32>] [<CommonParameters>]
``` 



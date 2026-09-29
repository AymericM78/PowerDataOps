# Command : `Watch-XrmAsynchOperation` 

## Description

**Monitor async operation completion.** : Poll the status of one or more system jobs (asyncoperation) until each one reaches a final status: Succeeded (30), Failed (31) or Canceled (32).
Returns one status object per job, in the order of AsyncOperationId: Id, StatusCode, Status (Waiting, InProgress, Succeeded, Failed, Canceled...), Message, FriendlyMessage.
The timeout applies whatever the job status, including a job stuck in progress, and raises an error that lists the unfinished jobs.
A job not found during 10 polls raises an error, unless MissingMeansSucceeded is set: some successful jobs are deleted as soon as they complete.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
AsyncOperationId|Guid[]|2|true||System job unique identifier(s).
PollingIntervalSeconds|Int32|3|false|5|Delay between each status check. (Default: 5)
ScriptBlock|ScriptBlock|4|false||Command to execute at each poll with the asyncoperation row (once the job has started). Its output is written to the host, not returned.
TimeoutInMinutes|Int32|5|false|60|Maximum time to wait for all jobs, whatever their status. (Default: 60)
MissingMeansSucceeded|SwitchParameter|named|false|False|Consider a job that cannot be found (deleted after completion) as succeeded, instead of raising an error.
ThrowOnFailure|SwitchParameter|named|false|False|Raise an error when a job ends Failed or Canceled, with its message.

## Outputs
PSCustomObject. One object per job: Id, StatusCode, Status, Message, FriendlyMessage.

## Usage

```Powershell 
Watch-XrmAsynchOperation [[-XrmClient] <ServiceClient>] [-AsyncOperationId] <Guid[]> [[-PollingIntervalSeconds] <Int32>] [[-ScriptBlock] <ScriptBlock>] [[-TimeoutInMinutes] <Int32>] [-MissingMeansSucceeded] [-ThrowOnFailure] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = $xrmClient | Invoke-XrmRequest -Request $request -Async;
$status = $xrmClient | Watch-XrmAsynchOperation -AsyncOperationId $response.AsyncJobId -ThrowOnFailure;
``` 


```Powershell 
$statuses = $xrmClient | Watch-XrmAsynchOperation -AsyncOperationId @($jobId1, $jobId2) -TimeoutInMinutes 30 -MissingMeansSucceeded;
$statuses | Where-Object { $_.Status -ne "Succeeded" };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Watch-XrmAsynchOperation.md



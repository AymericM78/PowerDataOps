# Command : `Invoke-XrmCustomApiLoop` 

## Description

**Call a custom API repeatedly, while a condition holds, up to a ceiling.** : Call the custom API (see Invoke-XrmCustomApi) until the While scriptblock returns false or MaxIterations calls were made: the "process by batches until nothing is left" pattern.
The While and OnIteration scriptblocks receive the output of the last call in $_ (the response, or the deserialized JSON with JsonOutput), and the output and the iteration number as arguments.
OnIteration output goes to the host. A failed call stops the loop with an error.
Returns Iterations, LastOutput and CeilingReached (true when the loop stopped on MaxIterations while While still returned true).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Custom API unique name (message name).
Parameters|Hashtable|3|false||Request parameters, by name, sent at each call. (Default: none)
While|ScriptBlock|4|true||Condition evaluated after each call: the loop goes on while it returns true (e.g. { $_.HasMore }).
MaxIterations|Int32|5|false|100|Maximum number of calls. (Default: 100)
OnIteration|ScriptBlock|6|false||Scriptblock run after each call, before While (e.g. to log progress).
JsonOutput|String|7|false||Name of an output parameter holding JSON: its deserialized value is given to the scriptblocks and returned as LastOutput.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
PSCustomObject. Iterations, LastOutput, CeilingReached.

## Usage

```Powershell 
Invoke-XrmCustomApiLoop [[-XrmClient] <ServiceClient>] [-Name] <String> [[-Parameters] <Hashtable>] [-While] <ScriptBlock> [[-MaxIterations] <Int32>] [[-OnIteration] <ScriptBlock>] [[-JsonOutput] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$result = Invoke-XrmCustomApiLoop -XrmClient $xrmClient -Name "contoso_PurgeLogs" -Parameters @{ BatchSize = 500 } -JsonOutput "Result" `
    -While { $_.HasMore } -MaxIterations 200 -OnIteration { param($output, $iteration) Write-Host "Batch $iteration : $($output.Deleted) deleted" };
if ($result.CeilingReached) { Write-Warning "Stopped after $($result.Iterations) batches, logs remain."; }
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Invoke-XrmCustomApiLoop.md



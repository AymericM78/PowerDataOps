# Command : `Upsert-XrmCloudFlow` 

## Description

**Create or update a cloud flow (solution-aware Power Automate flow).** : Write a cloud flow (workflow, category 5) with a caller-controlled Id, so the Id stays the same across environments.
An activated flow is turned off, written, then turned on again. With Activate, the flow is also turned on when it was off or new.
With SolutionUniqueName, the flow is added to the solution (idempotent).
Raises an error when the Id belongs to a process that is not a cloud flow, or when the flow cannot be turned on again (it then stays off).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|2|true||Flow unique identifier (workflowid).
Name|String|3|true||Flow name.
ClientData|String|4|true||Flow definition, as stored in the clientdata column (JSON with properties.definition and properties.connectionReferences).
Description|String|5|false||Flow description.
SolutionUniqueName|String|6|false||Unmanaged solution to add the flow to.
Activate|SwitchParameter|named|false|False|Turn the flow on after writing it, even when it was off or new.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference of the flow.

## Usage

```Powershell 
Upsert-XrmCloudFlow [[-XrmClient] <ServiceClient>] [-Id] <Guid> [-Name] <String> [-ClientData] <String> [[-Description] <String>] [[-SolutionUniqueName] <String>] [-Activate] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$clientData = Get-Content -Path ".\flows\SyncAccounts.json" -Raw;
$flow = Upsert-XrmCloudFlow -XrmClient $xrmClient -Id "5f0e2c1a-7a39-4a57-9d0b-2f1b8c3e4d5a" -Name "Sync accounts" -ClientData $clientData -SolutionUniqueName "MySolution" -Activate;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Upsert-XrmCloudFlow.md



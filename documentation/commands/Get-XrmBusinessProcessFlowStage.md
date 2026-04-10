# Command : `Get-XrmBusinessProcessFlowStage` 

## Description

**Retrieve a business process flow stage.** : Get a process stage record by stage name and process identifier.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
StageName|String|2|true||Name of the BPF stage to retrieve.
ProcessId|Guid|3|true||Business process flow unique identifier (workflow id).

## Outputs
System.Management.Automation.PSObject

## Usage

```Powershell 
Get-XrmBusinessProcessFlowStage [[-XrmClient] <ServiceClient>] [-StageName] <String> [-ProcessId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$stage = Get-XrmBusinessProcessFlowStage -XrmClient $xrmClient -StageName "Qualify" -ProcessId $bpfProcessId;
``` 



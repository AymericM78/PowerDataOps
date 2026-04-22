# Command : `Apply-XrmBusinessProcessFlowStage` 

## Description

**Apply a business process flow stage to a record.** : Set or create a BPF instance for a target record at a specified stage. If a BPF record already exists, 
updates the active stage and traversed path. Otherwise, creates a new BPF instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TargetRecordReference|EntityReference|2|true||Entity reference of the target record bound to the BPF.
TargetStageName|String|3|true||Name of the BPF stage to apply.
BpfEntityLogicalName|String|4|true||Logical name of the BPF entity (e.g., "leadtoopportunitysalesprocess").
BpfLookupAttributeName|String|5|true||Logical name of the BPF lookup attribute that references the target record.
ProcessId|Guid|6|true||Business process flow unique identifier (workflow id).


## Usage

```Powershell 
Apply-XrmBusinessProcessFlowStage [[-XrmClient] <ServiceClient>] [-TargetRecordReference] <EntityReference> [-TargetStageName] <String> 
[-BpfEntityLogicalName] <String> [-BpfLookupAttributeName] <String> [-ProcessId] <Guid> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$caseRef = New-XrmEntityReference -LogicalName "incident" -Id $caseId;
Apply-XrmBusinessProcessFlowStage -XrmClient $xrmClient -TargetRecordReference $caseRef -TargetStageName "Qualify" -BpfEntityLogicalName "df_casebpf" -BpfLookupAttributeName "bpf_df_caseid" -ProcessId $processId;
``` 



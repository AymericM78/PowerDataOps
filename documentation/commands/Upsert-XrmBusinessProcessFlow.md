# Command : `Upsert-XrmBusinessProcessFlow` 

## Description

**Create or update a Business Process Flow (BPF) definition in Microsoft Dataverse.** : Upsert a workflow record (category=4, BPF) by its workflow Id. When the record already exists in Dataverse,
the cmdlet updates xaml/name/processorder/... via Update-XrmRecord. Otherwise it creates a new workflow
using the provided Id (Add-XrmRecord).

Localized names are persisted via the SetLocLabels message (workflow.name) when bilingual labels are
supplied via -Labels.

When -SolutionUniqueName is provided, the workflow is registered as a component of the target unmanaged
solution (component type 29 - Workflow).

When -Activate is set (default $true), the workflow is activated at the end of the operation via
Enable-XrmWorkflow. Activation is what causes Dataverse to materialise the BPF instance entity
(e.g. aaa_bpf_opportunitytocontractprocess) - this entity must NOT be created manually; Dataverse
generates it automatically on first activation of the BPF.

TODO: -Roles array is accepted for forward compatibility but role-to-process assignment
(processroleassignment XML / Privilege records) is not handled in this iteration.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Id|Guid|named|true||Workflow Id (used as the upsert key - the BPF GUID consumed by the generated XAML class name).
UniqueName|String|named|true||Workflow unique name (publisher-prefixed, e.g. aaa_opportunitytocontractprocess).
PrimaryEntity|String|named|true||Logical name of the entity the BPF is anchored on (e.g. aaa_opportunity).
Name|String|named|true||Workflow display name. Used when -Labels is not provided.
Labels|Hashtable|named|true||Hashtable of language code to display name. Persisted as real translations via SetLocLabels.
Example: @{ 1033 = "Opportunity to Contract"; 1036 = "Opportunite vers Contrat" }.
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
Description|String|named|false||Workflow description.
Xaml|String|named|true||Workflow XAML definition (BPF activity tree). MUST embed the workflow Id (without dashes) in the
Activity x:Class attribute.
Category|Int32|named|false|4|Workflow category. 4 = Business Process Flow. Default: 4.
Type|Int32|named|false|1|Workflow type. 1 = Definition. Default: 1.
Mode|Int32|named|false|0|Workflow mode. 0 = Background. Default: 0.
Scope|Int32|named|false|4|Workflow scope. 4 = Organization. Default: 4.
BusinessProcessType|Int32|named|false|0|Business process type. 0 = Business Process Flow. Default: 0.
ProcessOrder|Int32|named|false|1|Order of the process in the entity's BPF picker. Default: 1.
RunAs|Int32|named|false|1|Run-as user code. 1 = Owner of the workflow record. Default: 1.
IsTransacted|Boolean|named|false|True|Whether the BPF runs in a transaction. Default: $true.
TriggerOnCreate|Boolean|named|false|True|Whether the BPF auto-starts on create of the primary entity. Default: $true.
IntroducedVersion|String|named|false||Solution-introduced version stamp.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the workflow is registered as a solution component (type 29).
Roles|String[]|named|false||Array of security role unique names (currently not assigned - see TODO above).
Activate|Boolean|named|false|True|Activate the workflow after upsert. Default: $true.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the upserted workflow record.

## Usage

```Powershell 
Upsert-XrmBusinessProcessFlow [-XrmClient <ServiceClient>] -Id <Guid> -UniqueName <String> -PrimaryEntity <String> -Name <String> [-LanguageCode <Int32>] [-Description <String>] -Xaml <String> [-Category <Int32>] [-Type <Int32>] [-Mode <Int32>] [-Scope <Int32>] [-BusinessProcessType <Int32>] [-ProcessOrder <Int32>] [-RunAs <Int32>] [-IsTransacted <Boolean>] [-TriggerOnCreate <Boolean>] [-IntroducedVersion <String>] [-SolutionUniqueName <String>] [-Roles <String[]>] [-Activate <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]

Upsert-XrmBusinessProcessFlow [-XrmClient <ServiceClient>] -Id <Guid> -UniqueName <String> -PrimaryEntity <String> -Labels <Hashtable> [-LanguageCode <Int32>] [-Description <String>] -Xaml <String> [-Category <Int32>] [-Type <Int32>] [-Mode <Int32>] [-Scope <Int32>] [-BusinessProcessType <Int32>] [-ProcessOrder <Int32>] [-RunAs <Int32>] [-IsTransacted <Boolean>] [-TriggerOnCreate <Boolean>] [-IntroducedVersion <String>] [-SolutionUniqueName <String>] [-Roles <String[]>] [-Activate <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Upsert-XrmBusinessProcessFlow -Id $processId -UniqueName "aaa_opportunitytocontractprocess" `
    -PrimaryEntity "aaa_opportunity" -Labels @{ 1033 = "Opportunity to Contract"; 1036 = "Opportunite vers Contrat" } `
    -Description "Opportunity BPF" -Xaml $xaml -SolutionUniqueName "svcmgr_workflows";
``` 



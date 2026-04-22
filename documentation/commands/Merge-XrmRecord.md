# Command : `Merge-XrmRecord` 

## Description

**Merge two records in Microsoft Dataverse.** : Merge a subordinate record into a target record using the Merge SDK message.
The subordinate record is deactivated after the merge.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TargetReference|EntityReference|2|true||EntityReference of the target (surviving) record.
SubordinateId|Guid|3|true||Guid of the subordinate (merged/deactivated) record.
UpdateContent|Entity|4|false||Entity object containing attribute values to update on the target record during merge. Optional.
PerformParentingChecks|Boolean|5|false|False|Whether to check if the parent information is different for the two records. Default: false.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The Merge response.

## Usage

```Powershell 
Merge-XrmRecord [[-XrmClient] <ServiceClient>] [-TargetReference] <EntityReference> [-SubordinateId] <Guid> [[-UpdateContent] <Entity>] 
[[-PerformParentingChecks] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$targetRef = New-XrmEntityReference -LogicalName "account" -Id $targetAccountId;
Merge-XrmRecord -TargetReference $targetRef -SubordinateId $duplicateAccountId;
``` 


```Powershell 
$update = New-XrmEntity -LogicalName "account" -Attributes @{ "telephone1" = "555-1234" };
Merge-XrmRecord -TargetReference $targetRef -SubordinateId $duplicateId -UpdateContent $update;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/merge



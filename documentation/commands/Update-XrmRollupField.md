# Command : `Update-XrmRollupField` 

## Description

**Recalculate a rollup field value.** : Force recalculation of a rollup field for a specific record using the CalculateRollupField SDK function.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RecordReference|EntityReference|2|true||EntityReference of the record to recalculate.
FieldName|String|3|true||Logical name of the rollup field.

## Outputs
Microsoft.Xrm.Sdk.Entity. The entity with the recalculated rollup field value.

## Usage

```Powershell 
Update-XrmRollupField [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [-FieldName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
$recordRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
$result = Update-XrmRollupField -RecordReference $recordRef -FieldName "new_totalrevenue";
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/calculaterollupfield



# Command : `Set-XrmRecordState` 

## Description

**Set the state and status of a record.** : Update the statecode and statuscode of a Dataverse record using Update-XrmRecord.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RecordReference|EntityReference|2|true||Entity reference of the target record.
StateCode|Int32|3|true|0|State code value to set (e.g., 0 = Active, 1 = Inactive).
StatusCode|Int32|4|true|0|Status code value to set. Must be valid for the given state code.


## Usage

```Powershell 
Set-XrmRecordState [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [-StateCode] <Int32> [-StatusCode] <Int32> [<CommonParameters>]
``` 

## Examples

```Powershell 
$xrmClient = New-XrmClient -ConnectionString $connectionString;
$accountRef = New-XrmEntityReference -LogicalName "account" -Id $accountId;
Set-XrmRecordState -XrmClient $xrmClient -RecordReference $accountRef -StateCode 1 -StatusCode 2;
``` 



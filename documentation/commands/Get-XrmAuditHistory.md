# Command : `Get-XrmAuditHistory` 

## Description

**Retrieve audit for given record.** : Get record audit history for given fields changes

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
RecordReference|EntityReference|2|true||Lookup to target record. (EntityReference)
AttributeFilter|String[]|3|false||Attributes logical names to filter.


## Usage

```Powershell 
Get-XrmAuditHistory [[-XrmClient] <ServiceClient>] [-RecordReference] <EntityReference> [[-AttributeFilter] <String[]>] [<CommonParameters>]
``` 



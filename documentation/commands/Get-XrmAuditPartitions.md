# Command : `Get-XrmAuditPartitions` 

## Description

**Retrieve audit partitions** : Get record audit logs with date range and size.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)


## Usage

```Powershell 
Get-XrmAuditPartitions [[-XrmClient] <ServiceClient>] [<CommonParameters>]
``` 



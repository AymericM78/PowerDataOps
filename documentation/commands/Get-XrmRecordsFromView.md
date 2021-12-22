# Command : `Get-XrmRecordsFromView` 

## Description

**Retrieve records from a view.** : Get records according to given view name.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
EntityLogicalName|String|2|true||
ViewName|String|3|true||Entity saved query name. Use auto completion to select proper one.


## Usage

```Powershell 
Get-XrmRecordsFromView [[-XrmClient] <CrmServiceClient>] [-EntityLogicalName] <String> [-ViewName] <String> 
[<CommonParameters>]
``` 



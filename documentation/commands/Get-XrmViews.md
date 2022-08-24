# Command : `Get-XrmViews` 

## Description

**Retrieve savedquery records.** : Get all saved query according to entity name and predefined columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
EntityLogicalName|String|2|true||
Columns|String[]|3|false|@("*")|Specify expected columns to retrieve. (Default : all columns)


## Usage

```Powershell 
Get-XrmViews [[-XrmClient] <CrmServiceClient>] [-EntityLogicalName] <String> [[-Columns] <String[]>] [<CommonParameters>]
``` 



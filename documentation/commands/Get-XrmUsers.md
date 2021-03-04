# Command : `Get-XrmUsers` 

## Description

**Retrieve users.** : Get all system users from instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@("fullname", "internalemailaddress")|Specify expected columns to retrieve. (Default : all columns)

## Outputs

## Usage

```Powershell 
Get-XrmUsers [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



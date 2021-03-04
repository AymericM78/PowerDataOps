# Command : `Get-XrmOrganization` 

## Description

**Get Organization object.** : Retrieve default organization record from target instance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|@("*")|Specify expected columns to retrieve. (Default : all columns)


## Usage

```Powershell 
Get-XrmOrganization [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



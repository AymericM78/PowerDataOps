﻿# Command : `Get-XrmThemes` 

## Description

**Retrieve theme records.** : Get themes with expected columns.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Columns|String[]|2|false|*|Specify expected columns to retrieve. (Default : All columns)


## Usage

```Powershell 
Get-XrmThemes [[-XrmClient] <CrmServiceClient>] [[-Columns] <String[]>] [<CommonParameters>]
``` 



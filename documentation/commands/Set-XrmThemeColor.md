﻿# Command : `Set-XrmThemeColor` 

## Description

**Change theme color.** : Set theme accent color.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|CrmServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (CrmServiceClient)
Name|String|2|true||
LabelAndLinkColor|String|3|true||
BackgroundColor|String|4|true||


## Usage

```Powershell 
Set-XrmThemeColor [[-XrmClient] <CrmServiceClient>] [-Name] <String> [-LabelAndLinkColor] <String> [-BackgroundColor] 
<String> [<CommonParameters>]
``` 



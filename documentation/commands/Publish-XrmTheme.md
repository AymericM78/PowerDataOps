# Command : `Publish-XrmTheme` 

## Description

**Publish theme.** : Apply theme to target instance

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||


## Usage

```Powershell 
Publish-XrmTheme [[-XrmClient] <ServiceClient>] [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 



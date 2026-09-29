# Command : `Remove-XrmEnvironmentVariableValue` 

## Description

**Remove the value (override) of an environment variable.** : Delete the value record of an environment variable, so that the default value of its definition applies again.
Nothing is done when the variable has no value record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Environment variable definition schema name.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmEnvironmentVariableValue [[-XrmClient] <ServiceClient>] [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmEnvironmentVariableValue -XrmClient $xrmClient -Name "new_ApiUrl";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Remove-XrmEnvironmentVariableValue.md



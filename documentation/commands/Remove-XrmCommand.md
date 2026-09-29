# Command : `Remove-XrmCommand` 

## Description

**Delete a command bar button from Microsoft Dataverse.** : Delete an appaction record (command bar button).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
CommandReference|EntityReference|2|true||EntityReference of the appaction to delete.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmCommand [[-XrmClient] <ServiceClient>] [-CommandReference] <EntityReference> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmCommand -CommandReference $cmdRef;
``` 



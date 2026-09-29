# Command : `Remove-XrmForm` 

## Description

**Delete a form from Microsoft Dataverse.** : Delete a systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FormReference|EntityReference|2|true||EntityReference of the systemform to delete.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
System.Void.

## Usage

```Powershell 
Remove-XrmForm [[-XrmClient] <ServiceClient>] [-FormReference] <EntityReference> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmForm -FormReference $formRef;
``` 



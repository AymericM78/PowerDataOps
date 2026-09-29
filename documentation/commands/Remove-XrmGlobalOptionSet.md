# Command : `Remove-XrmGlobalOptionSet` 

## Description

**Delete a global option set from Microsoft Dataverse.** : Delete a global option set using DeleteOptionSetRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Global option set name to delete.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteOptionSet response.

## Usage

```Powershell 
Remove-XrmGlobalOptionSet [[-XrmClient] <ServiceClient>] [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmGlobalOptionSet -Name "new_priority";
``` 



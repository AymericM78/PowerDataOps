# Command : `Remove-XrmRelationship` 

## Description

**Delete a relationship from Microsoft Dataverse.** : Delete a relationship using DeleteRelationshipRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Relationship schema name to delete.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteRelationship response.

## Usage

```Powershell 
Remove-XrmRelationship [[-XrmClient] <ServiceClient>] [-Name] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmRelationship -Name "new_account_contact";
``` 



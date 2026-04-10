# Command : `Remove-XrmRelationship` 

## Description

**Delete a relationship from Microsoft Dataverse.** : Delete a relationship using DeleteRelationshipRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Relationship schema name to delete.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteRelationship response.

## Usage

```Powershell 
Remove-XrmRelationship [[-XrmClient] <ServiceClient>] [-Name] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmRelationship -Name "new_account_contact";
``` 



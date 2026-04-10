# Command : `Remove-XrmTable` 

## Description

**Delete a table from Microsoft Dataverse.** : Delete an entity / table using DeleteEntityRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name to delete.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteEntity response.

## Usage

```Powershell 
Remove-XrmTable [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmTable -LogicalName "new_project";
``` 



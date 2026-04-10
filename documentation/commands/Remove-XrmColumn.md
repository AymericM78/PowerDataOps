# Command : `Remove-XrmColumn` 

## Description

**Delete a column from Microsoft Dataverse.** : Delete an attribute / column from a table using DeleteAttributeRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
LogicalName|String|3|true||Column / Attribute logical name to delete.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteAttribute response.

## Usage

```Powershell 
Remove-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-LogicalName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
``` 



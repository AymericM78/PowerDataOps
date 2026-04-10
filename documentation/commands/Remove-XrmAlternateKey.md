# Command : `Remove-XrmAlternateKey` 

## Description

**Delete an alternate key from a Microsoft Dataverse table.** : Delete an entity key using DeleteEntityKeyRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
LogicalName|String|3|true||Alternate key logical name to delete.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteEntityKey response.

## Usage

```Powershell 
Remove-XrmAlternateKey [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-LogicalName] <String> [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmAlternateKey -EntityLogicalName "account" -LogicalName "new_accountcode";
``` 



# Command : `Get-XrmAlternateKey` 

## Description

**Retrieve alternate key metadata from Microsoft Dataverse.** : Get entity key metadata using RetrieveEntityKeyRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
LogicalName|String|3|true||Alternate key logical name.
RetrieveAsIfPublished|Boolean|4|false|True|Retrieve metadata as if published. Default: true.

## Outputs
Microsoft.Xrm.Sdk.Metadata.EntityKeyMetadata. The alternate key metadata.

## Usage

```Powershell 
Get-XrmAlternateKey [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-LogicalName] <String> [[-RetrieveAsIfPublished] <Boolean>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$key = Get-XrmAlternateKey -EntityLogicalName "account" -LogicalName "new_accountcode";
``` 



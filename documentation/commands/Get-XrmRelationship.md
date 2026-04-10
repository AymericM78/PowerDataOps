# Command : `Get-XrmRelationship` 

## Description

**Retrieve relationship metadata from Microsoft Dataverse.** : Get relationship metadata using RetrieveRelationshipRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Relationship schema name.
RetrieveAsIfPublished|Boolean|3|false|True|Retrieve metadata as if published. Default: true.

## Outputs
Microsoft.Xrm.Sdk.Metadata.RelationshipMetadataBase. The relationship metadata.

## Usage

```Powershell 
Get-XrmRelationship [[-XrmClient] <ServiceClient>] [-Name] <String> [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$rel = Get-XrmRelationship -Name "new_account_contact";
``` 



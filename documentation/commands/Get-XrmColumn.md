# Command : `Get-XrmColumn` 

## Description

**Retrieve column metadata from Microsoft Dataverse.** : Get attribute / column metadata using RetrieveAttributeRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
LogicalName|String|3|true||Column / Attribute logical name.
RetrieveAsIfPublished|Boolean|4|false|True|Retrieve metadata as if published. Default: true.

## Outputs
Microsoft.Xrm.Sdk.Metadata.AttributeMetadata. The attribute metadata.

## Usage

```Powershell 
Get-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-LogicalName] <String> [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$column = Get-XrmColumn -EntityLogicalName "account" -LogicalName "name";
``` 



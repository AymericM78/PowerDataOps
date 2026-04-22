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
MetadataType|Type|5|false||Optional metadata type to enforce, such as [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata].
IfExists|SwitchParameter|named|false|False|Return $null instead of throwing when the column does not exist. When MetadataType is provided,
return $null if the column exists but is not of the expected metadata type.

## Outputs
Microsoft.Xrm.Sdk.Metadata.AttributeMetadata. The attribute metadata.

## Usage

```Powershell 
Get-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-LogicalName] <String> [[-RetrieveAsIfPublished] <Boolean>] [[-MetadataType] 
<Type>] [-IfExists] [<CommonParameters>]
``` 

## Examples

```Powershell 
$column = Get-XrmColumn -EntityLogicalName "account" -LogicalName "name";
``` 


```Powershell 
$column = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_status" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]) -IfExists;
``` 



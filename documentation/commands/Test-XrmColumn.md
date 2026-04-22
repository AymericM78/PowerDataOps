# Command : `Test-XrmColumn` 

## Description

**Verify whether a Dataverse column exists.** : Return $true when a column exists on the specified table. Optionally enforce a specific
metadata type such as [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata].

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
LogicalName|String|3|true||Column / Attribute logical name.
MetadataType|Type|4|false||Optional metadata type to enforce.
RetrieveAsIfPublished|Boolean|5|false|True|Retrieve metadata as if published. Default: true.

## Outputs
System.Boolean.

## Usage

```Powershell 
Test-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-LogicalName] <String> [[-MetadataType] <Type>] [[-RetrieveAsIfPublished] 
<Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Test-XrmColumn -EntityLogicalName "account" -LogicalName "name";
``` 


```Powershell 
Test-XrmColumn -EntityLogicalName "account" -LogicalName "new_status" -MetadataType ([Microsoft.Xrm.Sdk.Metadata.PicklistAttributeMetadata]);
``` 



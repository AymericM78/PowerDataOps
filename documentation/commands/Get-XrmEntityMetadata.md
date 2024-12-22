# Command : `Get-XrmEntityMetadata` 

## Description

**Retrieve entity metadata** : Get entity / table metadata.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
LogicalName|String|2|true||Table / Entity logical name.
Filter|EntityFilters|3|false|All|Filter to apply on metadata.
RetrieveAsIfPublished|Boolean|4|false|True|Retrieve metadata as if published.


## Usage

```Powershell 
Get-XrmEntityMetadata [[-XrmClient] <ServiceClient>] [-LogicalName] <String> [[-Filter] {Entity | Default | Attributes | Privileges | Relationships | All}] [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 



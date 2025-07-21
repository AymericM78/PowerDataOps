# Command : `Get-XrmAllEntityMetadata` 

## Description

**Retrieve all entity metadata** : Get list of entity / table metadata.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Filter|EntityFilters|2|false|All|Filter to apply on entities metadata.
RetrieveAsIfPublished|Boolean|3|false|True|Retrieve metadata as if published.


## Usage

```Powershell 
Get-XrmAllEntityMetadata [[-XrmClient] <ServiceClient>] [[-Filter] {Entity | Default | Attributes | Privileges | 
Relationships | All}] [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 



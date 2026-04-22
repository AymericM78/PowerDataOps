# Command : `Set-XrmTable` 

## Description

**Update a table in Microsoft Dataverse.** : Update an existing entity / table metadata using UpdateEntityRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityMetadata|EntityMetadata|2|true||The EntityMetadata object with updated properties.
SolutionUniqueName|String|3|false||Solution unique name context for the update.
MergeLabels|Boolean|4|false|True|Whether to merge labels. Default: true.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateEntity response.

## Usage

```Powershell 
Set-XrmTable [[-XrmClient] <ServiceClient>] [-EntityMetadata] <EntityMetadata> [[-SolutionUniqueName] <String>] [[-MergeLabels] <Boolean>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$metadata = Get-XrmEntityMetadata -LogicalName "account";
$metadata.DisplayName = New-XrmLabel -Text "Customer";
Set-XrmTable -EntityMetadata $metadata;
``` 



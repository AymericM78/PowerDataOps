# Command : `Add-XrmManyToManyRelationship` 

## Description

**Create a many-to-many relationship in Microsoft Dataverse.** : Create an N:N relationship using CreateManyToManyRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
ManyToManyRelationship|ManyToManyRelationshipMetadata|2|true||The ManyToManyRelationshipMetadata object defining the relationship.
IntersectEntityName|String|3|true||Logical name for the intersect entity.
SolutionUniqueName|String|4|false||Solution unique name to add the relationship to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateManyToMany response.

## Usage

```Powershell 
Add-XrmManyToManyRelationship [[-XrmClient] <ServiceClient>] [-ManyToManyRelationship] <ManyToManyRelationshipMetadata> [-IntersectEntityName] <String> [[-SolutionUniqueName] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$rel = [Microsoft.Xrm.Sdk.Metadata.ManyToManyRelationshipMetadata]::new();
$rel.SchemaName = "new_account_contact_nn";
$rel.Entity1LogicalName = "account";
$rel.Entity2LogicalName = "contact";
Add-XrmManyToManyRelationship -ManyToManyRelationship $rel -IntersectEntityName "new_account_contact";
``` 



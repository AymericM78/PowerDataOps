# Command : `Add-XrmOneToManyRelationship` 

## Description

**Create a one-to-many relationship in Microsoft Dataverse.** : Create a 1:N relationship using CreateOneToManyRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OneToManyRelationship|OneToManyRelationshipMetadata|2|true||The OneToManyRelationshipMetadata object defining the relationship.
Lookup|LookupAttributeMetadata|3|true||The LookupAttributeMetadata for the lookup column created on the many side.
SolutionUniqueName|String|4|false||Solution unique name to add the relationship to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateOneToMany response.

## Usage

```Powershell 
Add-XrmOneToManyRelationship [[-XrmClient] <ServiceClient>] [-OneToManyRelationship] <OneToManyRelationshipMetadata> [-Lookup] <LookupAttributeMetadata> [[-SolutionUniqueName] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
$rel = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
$rel.SchemaName = "new_account_contact";
$rel.ReferencedEntity = "account";
$rel.ReferencingEntity = "contact";
$rel.ReferencedAttribute = "accountid";
$lookup = [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]::new();
$lookup.SchemaName = "new_AccountId";
$lookup.DisplayName = New-XrmLabel -Text "Account";
Add-XrmOneToManyRelationship -OneToManyRelationship $rel -Lookup $lookup;
``` 



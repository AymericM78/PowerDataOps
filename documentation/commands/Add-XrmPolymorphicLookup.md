# Command : `Add-XrmPolymorphicLookup` 

## Description

**Create a polymorphic lookup attribute in Microsoft Dataverse.** : Create a polymorphic lookup column that can reference multiple table types using the CreatePolymorphicLookupAttribute SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Lookup|LookupAttributeMetadata|2|true||The LookupAttributeMetadata defining the polymorphic lookup column.
OneToManyRelationships|OneToManyRelationshipMetadata[]|3|true||Array of OneToManyRelationshipMetadata objects defining each target entity relationship.
SolutionUniqueName|String|4|false||Solution unique name to add the polymorphic lookup to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreatePolymorphicLookupAttribute response.

## Usage

```Powershell 
Add-XrmPolymorphicLookup [[-XrmClient] <ServiceClient>] [-Lookup] <LookupAttributeMetadata> [-OneToManyRelationships] <OneToManyRelationshipMetadata[]> 
[[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$lookup = [Microsoft.Xrm.Sdk.Metadata.LookupAttributeMetadata]::new();
$lookup.SchemaName = "new_RegardingId";
$lookup.DisplayName = New-XrmLabel -Text "Regarding";

$rel1 = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
$rel1.SchemaName = "new_account_regarding";
$rel1.ReferencedEntity = "account";
$rel1.ReferencingEntity = "new_custom";

$rel2 = [Microsoft.Xrm.Sdk.Metadata.OneToManyRelationshipMetadata]::new();
$rel2.SchemaName = "new_contact_regarding";
$rel2.ReferencedEntity = "contact";
$rel2.ReferencingEntity = "new_custom";

Add-XrmPolymorphicLookup -Lookup $lookup -OneToManyRelationships @($rel1, $rel2);
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/define-alternate-keys-entity#create-polymorphic-lookup



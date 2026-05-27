# Command : `Add-XrmColumn` 

## Description

**Create a new column in Microsoft Dataverse.** : Add a new attribute / column to a table using CreateAttributeRequest.
Use typed constructors such as New-XrmStringColumn, New-XrmBooleanColumn,
New-XrmIntegerColumn, New-XrmDecimalColumn, New-XrmDoubleColumn,
New-XrmMoneyColumn, New-XrmDateColumn, New-XrmChoiceColumn,
New-XrmMultiChoiceColumn, New-XrmFileColumn, New-XrmImageColumn,
New-XrmMemoColumn, and New-XrmAutoNumberColumn to build the
AttributeMetadata object.

Relationship-based lookups require specialized SDK messages and should use
Add-XrmOneToManyRelationship or Add-XrmPolymorphicLookup instead of
Add-XrmColumn.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
Attribute|AttributeMetadata|3|true||The AttributeMetadata object defining the column.
SolutionUniqueName|String|4|false||Solution unique name to add the column to.
IsAuditEnabled|Boolean|5|false|False|Whether auditing is enabled on the column. When specified, overrides the value set on the AttributeMetadata.
DisplayNameLabels|Hashtable|6|false||Hashtable of language code to display name for multilingual labels. When provided, overrides the DisplayName set on the AttributeMetadata. Example: @{ 1033 = "Code"; 1036 = "Code" }
DescriptionLabels|Hashtable|7|false||Hashtable of language code to description for multilingual labels. When provided, overrides the Description set on the AttributeMetadata.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateAttribute response.

## Usage

```Powershell 
Add-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-Attribute] <AttributeMetadata> [[-SolutionUniqueName] <String>] 
[[-IsAuditEnabled] <Boolean>] [[-DisplayNameLabels] <Hashtable>] [[-DescriptionLabels] <Hashtable>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attr = [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]::new();
$attr.LogicalName = "new_code";
$attr.SchemaName = "new_Code";
$attr.DisplayName = New-XrmLabel -Text "Code";
$attr.MaxLength = 50;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attr;
``` 


```Powershell 
$attr = New-XrmBooleanColumn -LogicalName "new_enabled" -SchemaName "new_Enabled" -DisplayName "Enabled" -DefaultValue $true;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attr;
``` 


```Powershell 
$attr = New-XrmStringColumn -LogicalName "new_code" -SchemaName "new_Code" -DisplayName "Code" -MaxLength 100;
Add-XrmColumn -EntityLogicalName "account" -Attribute $attr -DisplayNameLabels @{ 1033 = "Code"; 1036 = "Code projet" };
``` 

## More informations

https://learn.microsoft.com/power-apps/developer/data-platform/define-custom-columns



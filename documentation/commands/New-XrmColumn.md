# Command : `New-XrmColumn` 

## Description

**Create a new column in Microsoft Dataverse.** : Add a new attribute / column to a table using CreateAttributeRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
Attribute|AttributeMetadata|3|true||The AttributeMetadata object defining the column.
SolutionUniqueName|String|4|false||Solution unique name to add the column to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateAttribute response.

## Usage

```Powershell 
New-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-Attribute] <AttributeMetadata> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attr = [Microsoft.Xrm.Sdk.Metadata.StringAttributeMetadata]::new();
$attr.LogicalName = "new_code";
$attr.SchemaName = "new_Code";
$attr.DisplayName = New-XrmLabel -Text "Code";
$attr.MaxLength = 50;
New-XrmColumn -EntityLogicalName "account" -Attribute $attr;
``` 



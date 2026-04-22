# Command : `Set-XrmColumn` 

## Description

**Update a column in Microsoft Dataverse.** : Update an existing attribute / column metadata using UpdateAttributeRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
Attribute|AttributeMetadata|3|true||The AttributeMetadata object with updated properties.
SolutionUniqueName|String|4|false||Solution unique name context for the update.
MergeLabels|Boolean|5|false|True|Whether to merge labels. Default: true.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateAttribute response.

## Usage

```Powershell 
Set-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-Attribute] <AttributeMetadata> [[-SolutionUniqueName] <String>] 
[[-MergeLabels] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attr = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
$attr.DisplayName = New-XrmLabel -Text "Project Code";
Set-XrmColumn -EntityLogicalName "account" -Attribute $attr;
``` 



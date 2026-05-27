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
IsAuditEnabled|Boolean|6|false|False|Whether auditing is enabled on the column. When specified, overrides the value set on the AttributeMetadata.
EnableForInteractiveExperience|SwitchParameter|named|false|False|Enables the column for interactive dashboards (sets IsGlobalFilterEnabled and IsSortableEnabled).
DisplayNameLabels|Hashtable|7|false||Hashtable of language code to display name for multilingual labels. When provided, overrides the DisplayName set on the AttributeMetadata. Example: @{ 1033 = "Project Code"; 1036 = "Code projet" }
DescriptionLabels|Hashtable|8|false||Hashtable of language code to description for multilingual labels. When provided, overrides the Description set on the AttributeMetadata.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateAttribute response.

## Usage

```Powershell 
Set-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-Attribute] <AttributeMetadata> [[-SolutionUniqueName] <String>] 
[[-MergeLabels] <Boolean>] [[-IsAuditEnabled] <Boolean>] [-EnableForInteractiveExperience] [[-DisplayNameLabels] <Hashtable>] [[-DescriptionLabels] 
<Hashtable>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$attr = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
$attr.DisplayName = New-XrmLabel -Text "Project Code";
Set-XrmColumn -EntityLogicalName "account" -Attribute $attr;
``` 


```Powershell 
$attr = Get-XrmColumn -EntityLogicalName "account" -LogicalName "new_code";
Set-XrmColumn -EntityLogicalName "account" -Attribute $attr -DisplayNameLabels @{ 1033 = "Project Code"; 1036 = "Code projet" };
``` 



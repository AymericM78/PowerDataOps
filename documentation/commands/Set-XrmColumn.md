# Command : `Set-XrmColumn` 

## Description

**Update a column in Microsoft Dataverse.** : Update an existing attribute / column metadata using UpdateAttributeRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
Attribute|AttributeMetadata|3|false||The AttributeMetadata object with updated properties.
SolutionUniqueName|String|4|false||Solution unique name context for the update.
MergeLabels|Boolean|5|false|True|Whether to merge labels. Default: true. With DisplayNameLabels or DescriptionLabels, the current labels of the other languages are read and sent too: the platform would otherwise copy the given text into the language of the caller when it is missing.
IsAuditEnabled|Boolean|6|false|False|Whether auditing is enabled on the column. When specified, overrides the value set on the AttributeMetadata.
EnableForInteractiveExperience|SwitchParameter|named|false|False|Enables the column for interactive dashboards (sets IsGlobalFilterEnabled and IsSortableEnabled).
DisplayNameLabels|Hashtable|7|false||Hashtable of language code to display name for multilingual labels. When provided, overrides the DisplayName set on the AttributeMetadata. Example: @{ 1033 = "Project Code"; 1036 = "Code projet" }
DescriptionLabels|Hashtable|8|false||Hashtable of language code to description for multilingual labels. When provided, overrides the Description set on the AttributeMetadata.
LogicalName|String|9|false||Column logical name, instead of Attribute: a minimal metadata of the column type is sent, carrying only the given settings (the platform validates every property the request carries).
RequiredLevel|AttributeRequiredLevel|10|false||Requirement level: None, Recommended, ApplicationRequired. Raises an error when the column does not allow it to change (RequiredLevel.CanBeChanged), and when the level read back after the update is not the one asked (the platform can accept the request without applying it).
MinValue|Double|11|false|0|Minimum value of a whole number, decimal, float or currency column. The other bound is kept when not given.
MaxValue|Double|12|false|0|Maximum value of a whole number, decimal, float or currency column. The other bound is kept when not given.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateAttribute response.

## Usage

```Powershell 
Set-XrmColumn [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-Attribute] <AttributeMetadata>] [[-SolutionUniqueName] <String>] [[-MergeLabels] <Boolean>] [[-IsAuditEnabled] <Boolean>] [-EnableForInteractiveExperience] [[-DisplayNameLabels] <Hashtable>] [[-DescriptionLabels] <Hashtable>] [[-LogicalName] <String>] [[-RequiredLevel] {None | SystemRequired | ApplicationRequired | Recommended}] [[-MinValue] <Double>] [[-MaxValue] <Double>] [-WhatIf] [-Confirm] [<CommonParameters>]
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


```Powershell 
Set-XrmColumn -XrmClient $xrmClient -EntityLogicalName "account" -LogicalName "new_score" -RequiredLevel ApplicationRequired -MinValue 0 -MaxValue 1000;
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Set-XrmColumn.md



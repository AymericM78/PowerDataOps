# Command : `Set-XrmOptionSetValue` 

## Description

**Update an option value in an option set.** : Update an existing option value in a global or local option set using the UpdateOptionValue SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetName|String|2|false||Name of the global option set. Required for global option sets.
EntityLogicalName|String|3|false||Table / Entity logical name. Required for local option sets.
AttributeLogicalName|String|4|false||Attribute logical name. Required for local option sets.
Value|Int32|5|true|0|Integer value of the option to update.
Label|Label|6|false||New display label for the option (Label object from New-XrmLabel).
Description|Label|7|false||New description label for the option (Label object from New-XrmLabel).
Color|String|8|false||New hexadecimal color assigned to the option (e.g. "#FF0000").
ExternalValue|String|9|false||New external source value associated with the option.
ParentValues|Int32[]|10|false||New parent values associated with the option.
MergeLabels|Boolean|11|false|True|Whether to keep text defined for languages not included in the Label. Default: true.
SolutionUniqueName|String|12|false||Solution unique name to associate this update with.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateOptionValue response.

## Usage

```Powershell 
Set-XrmOptionSetValue [[-XrmClient] <ServiceClient>] [[-OptionSetName] <String>] [[-EntityLogicalName] <String>] [[-AttributeLogicalName] <String>] 
[-Value] <Int32> [[-Label] <Label>] [[-Description] <Label>] [[-Color] <String>] [[-ExternalValue] <String>] [[-ParentValues] <Int32[]>] [[-MergeLabels] 
<Boolean>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmOptionSetValue -OptionSetName "new_priority" -Value 100000 -Label (New-XrmLabel -Text "Critical Updated");
``` 


```Powershell 
Set-XrmOptionSetValue -EntityLogicalName "account" -AttributeLogicalName "new_category" -Value 100000 -Label (New-XrmLabel -Text "Premium Updated");
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/updateoptionvalue



# Command : `Add-XrmOptionSetValue` 

## Description

**Insert a new option value in an option set.** : Insert a new option value in a global or local option set using the InsertOptionValue SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetName|String|2|false||Name of the global option set. Required for global option sets.
EntityLogicalName|String|3|false||Table / Entity logical name. Required for local option sets.
AttributeLogicalName|String|4|false||Attribute logical name. Required for local option sets.
Value|Int32|5|false|0|Integer value for the new option. If not provided, the system assigns one.
Label|Label|6|true||Display label for the option (Label object from New-XrmLabel).
Description|Label|7|false||Description label for the option (Label object from New-XrmLabel).
Color|String|8|false||Hexadecimal color assigned to the option (e.g. "#FF0000").
ExternalValue|String|9|false||External source value associated with the option.
ParentValues|Int32[]|10|false||Parent values associated with the option.
SolutionUniqueName|String|11|false||Solution unique name to associate this option value with.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The InsertOptionValue response.

## Usage

```Powershell 
Add-XrmOptionSetValue [[-XrmClient] <ServiceClient>] [[-OptionSetName] <String>] [[-EntityLogicalName] <String>] [[-AttributeLogicalName] <String>] 
[[-Value] <Int32>] [-Label] <Label> [[-Description] <Label>] [[-Color] <String>] [[-ExternalValue] <String>] [[-ParentValues] <Int32[]>] 
[[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Add-XrmOptionSetValue -OptionSetName "new_priority" -Value 100000 -Label (New-XrmLabel -Text "Critical");
``` 


```Powershell 
Add-XrmOptionSetValue -EntityLogicalName "account" -AttributeLogicalName "new_category" -Value 100000 -Label (New-XrmLabel -Text "Premium");
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/insertoptionvalue



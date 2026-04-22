# Command : `Remove-XrmOptionSetValue` 

## Description

**Delete an option value from an option set.** : Delete an option value from a global or local option set using the DeleteOptionValue SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetName|String|2|false||Name of the global option set. Required for global option sets.
EntityLogicalName|String|3|false||Table / Entity logical name. Required for local option sets.
AttributeLogicalName|String|4|false||Attribute logical name. Required for local option sets.
Value|Int32|5|true|0|Integer value of the option to delete.
SolutionUniqueName|String|6|false||Solution unique name associated with this option value.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The DeleteOptionValue response.

## Usage

```Powershell 
Remove-XrmOptionSetValue [[-XrmClient] <ServiceClient>] [[-OptionSetName] <String>] [[-EntityLogicalName] <String>] [[-AttributeLogicalName] <String>] 
[-Value] <Int32> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Remove-XrmOptionSetValue -OptionSetName "new_priority" -Value 100000;
``` 


```Powershell 
Remove-XrmOptionSetValue -EntityLogicalName "account" -AttributeLogicalName "new_category" -Value 100000;
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/deleteoptionvalue



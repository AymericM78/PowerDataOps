# Command : `Set-XrmOptionSetOrder` 

## Description

**Set the display order of option set values.** : Reorder the values of a global or local option set using the OrderOption SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetName|String|2|false||Name of the global option set. Use this for global option sets.
EntityLogicalName|String|3|false||Entity logical name for local option sets.
AttributeLogicalName|String|4|false||Attribute logical name for local option sets.
Values|Int32[]|5|true||Array of option set integer values in the desired display order.
SolutionUniqueName|String|6|false||Solution unique name for tracking the change. Optional.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The OrderOption response.

## Usage

```Powershell 
Set-XrmOptionSetOrder [[-XrmClient] <ServiceClient>] [[-OptionSetName] <String>] [[-EntityLogicalName] <String>] [[-AttributeLogicalName] <String>] 
[-Values] <Int32[]> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmOptionSetOrder -OptionSetName "new_priority" -Values @(1, 3, 2, 4);
Set-XrmOptionSetOrder -EntityLogicalName "account" -AttributeLogicalName "new_category" -Values @(100, 200, 300);
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/orderoption



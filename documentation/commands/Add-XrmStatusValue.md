# Command : `Add-XrmStatusValue` 

## Description

**Insert a new status value (status reason) for a table.** : Add a new status reason value to a Status attribute using the InsertStatusValue SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Logical name of the entity.
AttributeLogicalName|String|3|false|statuscode|Logical name of the status attribute (typically "statuscode").
Label|String|4|true||Display label for the new status value.
StateCode|Int32|5|true|0|The state code (statecode value) this status reason belongs to (e.g. 0 = Active, 1 = Inactive).
Value|Int32|6|false|0|Specific integer value for the new status. Optional â€” auto-assigned by the platform if not specified.
LanguageCode|Int32|7|false|1033|Language code for the label. Default: 1033 (English).
SolutionUniqueName|String|8|false||Solution unique name for tracking the change. Optional.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The InsertStatusValue response containing the new value.

## Usage

```Powershell 
Add-XrmStatusValue [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [[-AttributeLogicalName] <String>] [-Label] <String> [-StateCode] <Int32> 
[[-Value] <Int32>] [[-LanguageCode] <Int32>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$response = Add-XrmStatusValue -EntityLogicalName "incident" -AttributeLogicalName "statuscode" -Label "Waiting for Customer" -StateCode 0;
$newValue = $response.Results["NewOptionalValue"];
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/insertstatusvalue



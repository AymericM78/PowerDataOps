# Command : `Set-XrmStateValue` 

## Description

**Update a state value in a StateAttributeMetadata attribute.** : Update the label and description of a statecode option using the UpdateStateValue SDK message.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name that has the statecode attribute.
AttributeLogicalName|String|3|true||Logical name of the state attribute.
Value|Int32|4|true|0|The statecode option value to update.
Label|Label|5|false||New display label for the statecode option (Label object from New-XrmLabel).
Description|Label|6|false||New description label for the statecode option (Label object from New-XrmLabel).
DefaultStatusCode|Int32|7|false|0|Default value for the statuscode (status reason) when this statecode is set.
MergeLabels|Boolean|8|false|True|Whether to merge the current label with existing labels. Default: true.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The UpdateStateValue response.

## Usage

```Powershell 
Set-XrmStateValue [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-AttributeLogicalName] <String> [-Value] <Int32> [[-Label] <Label>] 
[[-Description] <Label>] [[-DefaultStatusCode] <Int32>] [[-MergeLabels] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmStateValue -EntityLogicalName "incident" -AttributeLogicalName "statecode" -Value 0 -Label (New-XrmLabel -Text "Active Case");
``` 

## More informations

https://learn.microsoft.com/en-us/power-apps/developer/data-platform/webapi/reference/updatestatevalue



# Command : `Set-XrmGlobalOptionSetOptions` 

## Description

**Synchronize the options of a global option set.** : Update the list of options of an existing global option set from a typed OptionMetadata list.
Existing values are updated with Set-XrmOptionSetValue, missing values are created with
Add-XrmOptionSetValue, and extra values can optionally be removed.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Global option set name.
Options|OptionMetadata[]|3|true||Desired option list.
DisplayName|Label|4|false||Optional updated display label for the global option set.
Description|Label|5|false||Optional updated description label for the global option set.
MergeLabels|Boolean|6|false|True|Whether to keep text defined for languages not included in the Label. Default: true.
RemoveAbsentOptions|SwitchParameter|named|false|False|Remove existing option values that are not present in the desired option list.
SolutionUniqueName|String|7|false||Solution unique name context for the update.

## Outputs
Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase.

## Usage

```Powershell 
Set-XrmGlobalOptionSetOptions [[-XrmClient] <ServiceClient>] [-Name] <String> [-Options] <OptionMetadata[]> [[-DisplayName] <Label>] [[-Description] 
<Label>] [[-MergeLabels] <Boolean>] [-RemoveAbsentOptions] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$options = @(
(New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
);
Set-XrmGlobalOptionSetOptions -Name "new_priority" -Options $options -RemoveAbsentOptions;
``` 



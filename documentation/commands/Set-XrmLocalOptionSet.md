# Command : `Set-XrmLocalOptionSet` 

## Description

**Synchronize the local options of a choice column.** : Update the list of options of an existing local choice or multichoice column from a typed
OptionMetadata list. Existing values are updated with Set-XrmOptionSetValue, missing values
are created with Add-XrmOptionSetValue, and extra values can optionally be removed.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
EntityLogicalName|String|2|true||Table / Entity logical name.
AttributeLogicalName|String|3|true||Choice or multichoice attribute logical name.
Options|OptionMetadata[]|4|true||Desired option list.
MergeLabels|Boolean|5|false|True|Whether to keep text defined for languages not included in the Label. Default: true.
RemoveAbsentOptions|SwitchParameter|named|false|False|Remove existing option values that are not present in the desired option list.
SolutionUniqueName|String|6|false||Solution unique name context for the update.

## Outputs
Microsoft.Xrm.Sdk.Metadata.AttributeMetadata.

## Usage

```Powershell 
Set-XrmLocalOptionSet [[-XrmClient] <ServiceClient>] [-EntityLogicalName] <String> [-AttributeLogicalName] <String> [-Options] <OptionMetadata[]> 
[[-MergeLabels] <Boolean>] [-RemoveAbsentOptions] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$options = @(
(New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
);
Set-XrmLocalOptionSet -EntityLogicalName "account" -AttributeLogicalName "new_priority" -Options $options -RemoveAbsentOptions;
``` 



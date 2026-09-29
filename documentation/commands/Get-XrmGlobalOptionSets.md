# Command : `Get-XrmGlobalOptionSets` 

## Description

**Retrieve every global option set (choice) definition.** : Get the metadata of all global option sets (RetrieveAllOptionSets): OptionSetMetadata, or BooleanOptionSetMetadata for the global yes/no choices.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
RetrieveAsIfPublished|Boolean|2|false|True|Include the unpublished changes. (Default: true)
CustomOnly|SwitchParameter|named|false|False|Keep the custom option sets (IsCustomOptionSet).

## Outputs
Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase[].

## Usage

```Powershell 
Get-XrmGlobalOptionSets [[-XrmClient] <ServiceClient>] [[-RetrieveAsIfPublished] <Boolean>] [-CustomOnly] [<CommonParameters>]
``` 

## Examples

```Powershell 
Get-XrmGlobalOptionSets -XrmClient $xrmClient -CustomOnly | Select-Object Name, @{ Name = "Options"; Expression = { $_.Options.Count } };
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/commands/Get-XrmGlobalOptionSets.md



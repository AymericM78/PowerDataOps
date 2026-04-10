# Command : `Get-XrmGlobalOptionSet` 

## Description

**Retrieve a global option set from Microsoft Dataverse.** : Get global option set metadata using RetrieveOptionSetRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Global option set name.
RetrieveAsIfPublished|Boolean|3|false|True|Retrieve metadata as if published. Default: true.

## Outputs
Microsoft.Xrm.Sdk.Metadata.OptionSetMetadataBase. The global option set metadata.

## Usage

```Powershell 
Get-XrmGlobalOptionSet [[-XrmClient] <ServiceClient>] [-Name] <String> [[-RetrieveAsIfPublished] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$optionSet = Get-XrmGlobalOptionSet -Name "new_status";
``` 



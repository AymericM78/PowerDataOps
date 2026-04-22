# Command : `Add-XrmGlobalOptionSet` 

## Description

**Create a global option set in Microsoft Dataverse.** : Create a new global option set using CreateOptionSetRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetMetadata|OptionSetMetadataBase|2|true||The OptionSetMetadata object defining the global option set.
SolutionUniqueName|String|3|false||Solution unique name to add the global option set to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateOptionSet response.

## Usage

```Powershell 
Add-XrmGlobalOptionSet [[-XrmClient] <ServiceClient>] [-OptionSetMetadata] <OptionSetMetadataBase> [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$os = [Microsoft.Xrm.Sdk.Metadata.OptionSetMetadata]::new();
$os.Name = "new_priority";
$os.DisplayName = New-XrmLabel -Text "Priority";
$os.IsGlobal = $true;
$os.OptionSetType = [Microsoft.Xrm.Sdk.Metadata.OptionSetType]::Picklist;
Add-XrmGlobalOptionSet -OptionSetMetadata $os;
``` 



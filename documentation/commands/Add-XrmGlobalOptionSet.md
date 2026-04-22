# Command : `Add-XrmGlobalOptionSet` 

## Description

**Create a global option set in Microsoft Dataverse.** : Create a new global option set using CreateOptionSetRequest.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
OptionSetMetadata|OptionSetMetadataBase|named|true||The OptionSetMetadata object defining the global option set.
Name|String|named|true||Global option set name when creating from a typed option definition list.
DisplayName|Label|named|true||Global option set display label when creating from a typed option definition list.
Options|OptionMetadata[]|named|true||Global option set options when creating from a typed option definition list.
Description|Label|named|false||Optional global option set description label when creating from a typed option definition list.
SolutionUniqueName|String|named|false||Solution unique name to add the global option set to.

## Outputs
Microsoft.Xrm.Sdk.OrganizationResponse. The CreateOptionSet response.

## Usage

```Powershell 
Add-XrmGlobalOptionSet [-XrmClient <ServiceClient>] -OptionSetMetadata <OptionSetMetadataBase> [-SolutionUniqueName <String>] [<CommonParameters>]

Add-XrmGlobalOptionSet [-XrmClient <ServiceClient>] -Name <String> -DisplayName <Label> -Options <OptionMetadata[]> [-Description <Label>] 
[-SolutionUniqueName <String>] [<CommonParameters>]
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


```Powershell 
$options = @(
(New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD"),
    (New-XrmOption -Value 100000001 -Label (New-XrmLabel -Text "High") -Color "#FCE1E4")
);
Add-XrmGlobalOptionSet -Name "new_priority" -DisplayName (New-XrmLabel -Text "Priority") -Options $options;
``` 



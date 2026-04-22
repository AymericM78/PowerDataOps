# Command : `New-XrmOption` 

## Description

**Build an OptionMetadata object for Dataverse option sets.** : Creates a configured Microsoft.Xrm.Sdk.Metadata.OptionMetadata object that can be reused
when creating global option sets, local choice columns, or synchronizing option values.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Value|Int32|1|true|0|Integer value of the option.
Label|Label|2|true||Display label for the option.
Description|Label|3|false||Optional description label.
Color|String|4|false||Optional hexadecimal color (for example #5B8DEF).
IsManaged|Nullable`1|5|false||Optional managed state.
ExternalValue|String|6|false||Optional external value.
ParentValues|Int32[]|7|false||Optional parent values for hierarchical choices.
Tag|String|8|false||Optional tag value.

Dataverse exposes `IsHidden` with a non-public setter on OptionMetadata, so it is not configurable through this helper.

## Outputs
Microsoft.Xrm.Sdk.Metadata.OptionMetadata.

## Usage

```Powershell 
New-XrmOption [-Value] <Int32> [-Label] <Label> [[-Description] <Label>] [[-Color] <String>] [[-IsManaged] <Nullable`1>] [[-ExternalValue] <String>] 
[[-ParentValues] <Int32[]>] [[-Tag] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$option = New-XrmOption -Value 100000000 -Label (New-XrmLabel -Text "Low") -Color "#CDDAFD";
``` 



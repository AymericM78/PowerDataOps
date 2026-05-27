# Command : `Add-XrmCommand` 

## Description

**Create a new command bar button in Microsoft Dataverse.** : Create a new appaction record (command bar button).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|named|true||Command display name.
Labels|Hashtable|named|true||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). Note: this sets the command's 'name' attribute; the button text shown to users is -ButtonLabelText. Example: @{ 1033 = "Approve"; 1036 = "Approuver" }
LanguageCode|Int32|named|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
UniqueName|String|named|true||Unique name for the command.
Type|Int32|named|true|0|Action type (0=Standard, 1=Dropdown, 2=SplitButton, 3=Group).
Context|Int32|named|true|0|Context (0=All, 1=Entity).
Location|Int32|named|true|0|Location of the Command bar associated with the Modern Command. (0=Form, 1=Main Grid, 2=Sub Grid, 3=Associated Grid, 4=Quick Form, 5=Global Header, 6=Dashboard).
ContextEntity|String|named|false||Entity logical name when context is Entity.
ContextValue|String|named|false||Context value string.
ButtonLabelText|String|named|false||Button label text.
TooltipTitle|String|named|false||Tooltip title text.
Hidden|Boolean|named|false|False|Whether the command is hidden. Default: false.
SolutionUniqueName|String|named|false||Unmanaged solution unique name. When provided, the created command is automatically added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created appaction record.

## Usage

```Powershell 
Add-XrmCommand [-XrmClient <ServiceClient>] -Name <String> [-LanguageCode <Int32>] -UniqueName <String> -Type <Int32> -Context <Int32> -Location <Int32> 
[-ContextEntity <String>] [-ContextValue <String>] [-ButtonLabelText <String>] [-TooltipTitle <String>] [-Hidden <Boolean>] [-SolutionUniqueName 
<String>] [<CommonParameters>]

Add-XrmCommand [-XrmClient <ServiceClient>] -Labels <Hashtable> [-LanguageCode <Int32>] -UniqueName <String> -Type <Int32> -Context <Int32> -Location 
<Int32> [-ContextEntity <String>] [-ContextValue <String>] [-ButtonLabelText <String>] [-TooltipTitle <String>] [-Hidden <Boolean>] [-SolutionUniqueName 
<String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -ContextEntity "account" -ButtonLabelText "Approve";
$ref = Add-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -Location 0 -ButtonLabelText "Approve" -SolutionUniqueName "MySolution";
``` 


```Powershell 
$ref = Add-XrmCommand -Labels @{ 1033 = "Approve"; 1036 = "Approuver" } -LanguageCode 1036 -UniqueName "new_approve" -Type 0 -Context 1 -Location 0 -ButtonLabelText "Approuver";
``` 



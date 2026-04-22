# Command : `Add-XrmCommand` 

## Description

**Create a new command bar button in Microsoft Dataverse.** : Create a new appaction record (command bar button).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Command display name.
UniqueName|String|3|true||Unique name for the command.
Type|Int32|4|true|0|Action type (0=Standard, 1=Dropdown, 2=SplitButton, 3=Group).
Context|Int32|5|true|0|Context (0=All, 1=Entity).
Location|Int32|6|true|0|Location of the Command bar associated with the Modern Command. (0=Form, 1=Main Grid, 2=Sub Grid, 3=Associated Grid, 4=Quick Form, 5=Global Header, 6=Dashboard).
ContextEntity|String|7|false||Entity logical name when context is Entity.
ContextValue|String|8|false||Context value string.
ButtonLabelText|String|9|false||Button label text.
TooltipTitle|String|10|false||Tooltip title text.
Hidden|Boolean|11|false|False|Whether the command is hidden. Default: false.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created appaction record.

## Usage

```Powershell 
Add-XrmCommand [[-XrmClient] <ServiceClient>] [-Name] <String> [-UniqueName] <String> [-Type] <Int32> [-Context] <Int32> [-Location] <Int32> 
[[-ContextEntity] <String>] [[-ContextValue] <String>] [[-ButtonLabelText] <String>] [[-TooltipTitle] <String>] [[-Hidden] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = Add-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -ContextEntity "account" -ButtonLabelText "Approve";
``` 



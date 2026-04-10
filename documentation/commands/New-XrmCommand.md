# Command : `New-XrmCommand` 

## Description

**Create a new command bar button in Microsoft Dataverse.** : Create a new appaction record (command bar button).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
Name|String|2|true||Command display name.
UniqueName|String|3|true||Unique name for the command.
Type|Int32|4|true|0|Action type (0=Standard, 1=Dropdown, 2=SplitButton, 3=Group).
Context|Int32|5|true|0|Context (0=All, 1=Entity, 2=Global).
ContextEntity|String|6|false||Entity logical name when context is Entity.
ContextValue|String|7|false||Context value string.
ButtonLabelText|String|8|false||Button label text.
TooltipTitle|String|9|false||Tooltip title text.
Hidden|Boolean|10|false|False|Whether the command is hidden. Default: false.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the created appaction record.

## Usage

```Powershell 
New-XrmCommand [[-XrmClient] <ServiceClient>] [-Name] <String> [-UniqueName] <String> [-Type] <Int32> [-Context] <Int32> [[-ContextEntity] <String>] [[-ContextValue] <String>] [[-ButtonLabelText] 
<String>] [[-TooltipTitle] <String>] [[-Hidden] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$ref = New-XrmCommand -Name "Approve" -UniqueName "new_approve" -Type 0 -Context 1 -ContextEntity "account" -ButtonLabelText "Approve";
``` 



# Command : `Set-XrmCommand` 

## Description

**Update a command bar button in Microsoft Dataverse.** : Update an existing appaction record (command bar button).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
CommandReference|EntityReference|2|true||EntityReference of the appaction to update.
Name|String|3|false||Updated command display name.
ButtonLabelText|String|4|false||Updated button label text.
TooltipTitle|String|5|false||Updated tooltip title text.
Hidden|Boolean|6|false|False|Updated hidden state.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated appaction record.

## Usage

```Powershell 
Set-XrmCommand [[-XrmClient] <ServiceClient>] [-CommandReference] <EntityReference> [[-Name] <String>] [[-ButtonLabelText] <String>] [[-TooltipTitle] 
<String>] [[-Hidden] <Boolean>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmCommand -CommandReference $cmdRef -ButtonLabelText "Approve Request";
``` 



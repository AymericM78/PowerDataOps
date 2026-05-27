# Command : `Set-XrmCommand` 

## Description

**Update a command bar button in Microsoft Dataverse.** : Update an existing appaction record (command bar button).

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
CommandReference|EntityReference|2|true||EntityReference of the appaction to update.
Name|String|3|false||Updated command display name.
Labels|Hashtable|4|false||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). -Name takes precedence if both are provided. Note: the button text shown to users is -ButtonLabelText.
LanguageCode|Int32|5|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
ButtonLabelText|String|6|false||Updated button label text.
TooltipTitle|String|7|false||Updated tooltip title text.
Hidden|Boolean|8|false|False|Updated hidden state.
SolutionUniqueName|String|9|false||Unmanaged solution unique name. When provided, the updated command is automatically added to this solution.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated appaction record.

## Usage

```Powershell 
Set-XrmCommand [[-XrmClient] <ServiceClient>] [-CommandReference] <EntityReference> [[-Name] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] 
[[-ButtonLabelText] <String>] [[-TooltipTitle] <String>] [[-Hidden] <Boolean>] [[-SolutionUniqueName] <String>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmCommand -CommandReference $cmdRef -ButtonLabelText "Approve Request";
Set-XrmCommand -CommandReference $cmdRef -ButtonLabelText "Approve Request" -SolutionUniqueName "MySolution";
``` 



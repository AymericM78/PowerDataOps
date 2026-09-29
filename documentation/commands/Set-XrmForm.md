# Command : `Set-XrmForm` 

## Description

**Update a form in Microsoft Dataverse.** : Update an existing systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FormReference|EntityReference|2|true||EntityReference of the systemform to update.
Name|String|3|false||Updated form display name.
Labels|Hashtable|4|false||Hashtable of language code to display name. Alternative to -Name. The stored 'name' is resolved from -LanguageCode (fallback: lowest language code). -Name takes precedence if both are provided.
LanguageCode|Int32|5|false|1033|Language code used to pick the stored 'name' from -Labels. Default: 1033.
FormXml|String|6|false||Updated form XML definition.
Description|String|7|false||Updated description.
SolutionUniqueName|String|8|false||Unmanaged solution unique name. When provided, the updated form is automatically added to this solution.
WhatIf|SwitchParameter|named|false||
Confirm|SwitchParameter|named|false||

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

## Usage

```Powershell 
Set-XrmForm [[-XrmClient] <ServiceClient>] [-FormReference] <EntityReference> [[-Name] <String>] [[-Labels] <Hashtable>] [[-LanguageCode] <Int32>] [[-FormXml] <String>] [[-Description] <String>] [[-SolutionUniqueName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmForm -FormReference $formRef -Name "Updated Main Form" -FormXml $newXml;
Set-XrmForm -FormReference $formRef -FormXml $newXml -SolutionUniqueName "MySolution";
``` 



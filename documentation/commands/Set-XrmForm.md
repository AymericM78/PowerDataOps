# Command : `Set-XrmForm` 

## Description

**Update a form in Microsoft Dataverse.** : Update an existing systemform record.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|1|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
FormReference|EntityReference|2|true||EntityReference of the systemform to update.
Name|String|3|false||Updated form display name.
FormXml|String|4|false||Updated form XML definition.
Description|String|5|false||Updated description.

## Outputs
Microsoft.Xrm.Sdk.EntityReference. Reference to the updated systemform record.

## Usage

```Powershell 
Set-XrmForm [[-XrmClient] <ServiceClient>] [-FormReference] <EntityReference> [[-Name] <String>] [[-FormXml] <String>] [[-Description] <String>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
Set-XrmForm -FormReference $formRef -Name "Updated Main Form" -FormXml $newXml;
``` 



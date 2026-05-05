# Command : `Get-XrmDocumentTemplate` 

## Description

**Retrieve Dataverse document templates.** : Get a Dataverse document template by reference or by name, with optional entity disambiguation.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Xrm connector initialized to target instance. Use latest one by default. (Dataverse ServiceClient)
TemplateReference|EntityReference|named|true||EntityReference of the Dataverse document template.
TemplateName|String|named|true||Name of the Dataverse document template.
AssociatedEntityLogicalName|String|named|false||Optional logical name of the entity associated with the document template. Use it to disambiguate templates with the same name.
Columns|String[]|named|false|@('*')|Specify expected columns to retrieve. (Default : all columns)

## Outputs
PSCustomObject. Dataverse document template record.

## Usage

```Powershell 
Get-XrmDocumentTemplate [-XrmClient <ServiceClient>] -TemplateReference <EntityReference> [-Columns <String[]>] [<CommonParameters>]

Get-XrmDocumentTemplate [-XrmClient <ServiceClient>] -TemplateName <String> [-AssociatedEntityLogicalName <String>] [-Columns <String[]>] 
[<CommonParameters>]
``` 

## Examples

```Powershell 
Get-XrmDocumentTemplate -TemplateName "Invoice Template";
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md



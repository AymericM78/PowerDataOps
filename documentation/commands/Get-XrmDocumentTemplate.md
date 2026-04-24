# Command : `Get-XrmDocumentTemplate` 

## Description

**Retrieve Dataverse document templates.** : Get a Dataverse document template by reference or by name, with optional entity disambiguation.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
XrmClient|ServiceClient|named|false|$Global:XrmClient|Dataverse connection.
TemplateReference|EntityReference|named|false||EntityReference of the Dataverse document template.
TemplateName|String|named|false||Name of the Dataverse document template.
AssociatedEntityLogicalName|String|named|false||Optional logical name of the associated entity. Use it to disambiguate templates with the same name.
Columns|String[]|named|false|*|Specify expected columns to retrieve.

## Outputs
PSCustomObject. Dataverse document template record.

## Usage

```Powershell 
Get-XrmDocumentTemplate [[-XrmClient] <ServiceClient>] [-TemplateReference] <EntityReference> [[-Columns] <String[]>] [<CommonParameters>]

Get-XrmDocumentTemplate [[-XrmClient] <ServiceClient>] [-TemplateName] <String> [[-AssociatedEntityLogicalName] <String>] [[-Columns] <String[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
Get-XrmDocumentTemplate -TemplateName "Invoice Template";

Get-XrmDocumentTemplate -TemplateName "Expense Template" -AssociatedEntityLogicalName "sample_expense" -Columns 'name', 'associatedentitytypecode';
``` 

## More informations

https://github.com/AymericM78/PowerDataOps/blob/main/documentation/usage.md

